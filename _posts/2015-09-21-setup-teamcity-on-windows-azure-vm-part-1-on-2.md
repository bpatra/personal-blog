---
layout: post
title: TeamCity on Windows Azure VM part 1/2 - server setup
date: '2015-09-21 18:39:21 +0000'
categories:
- Programming
- Continuous Integration
tags:
- azure
- azure sql
- jetbrains
- reverse proxy
- teamcity
- windows azure
---
TeamCity is a continuous integration (CI) server developed by <a href="https://www.jetbrains.com">Jetbrains</a>. I have worked with <a href="http://www.cruisecontrolnet.org">CruiseControl </a> and <a href="http://jenkins-ci.org">Hudson/Jenkins </a> and, to my point-of-view, TeamCity is beyond comparison. I will not detail all the features that made me&nbsp;love this product, let me&nbsp;sum up by saying that TeamCity is both a powerful and easy to use software. It is so easy to use that you can let non tech guys visit the web app, trigger their own builds, collect artifacts etc.<br />
TeamCity 9.1 has been developed with the Tomcat/JEE tech stack. However, it works on windows and, in this post, I will explain how to setup a proper installation on Windows VM hosted on&nbsp;Azure using Azure SQL. Precisely, I will detail the following points


* Installing TeamCity 9.1 on a Windows Server 2012 Virtual Marchine hosted on Azure with and SQL Azure database.
* Serving your TeamCity web app securely through&nbsp;https. To this aim, we will setup a reverse proxy&nbsp;on IIS (Internet Information Services). &nbsp;I will also detail how to make&nbsp;the websockets, used by the TeamCity GUI, work with IIS 8.0.


This first post is dedicated only to the first point. The second one will be the topic of the next post.

# Installing Teamcity 9.0 on Azure VM
## creating the VM
First of all, start by creating the VM. I recommend you to use <a href="http://manage.windowsazure.com">manage.windowsazure.com</a>. I personally think that <a href="http://portal.azure.com">portal.azure.com</a> is not very clear for creating resources at the time of the writing. You can use the 'Quick create' feature. There is nothing particular, no special tricks here. Azure will create a virtual machine with Windows Server 2012. Note that I recommend you to provide a instance with more resources while you are configuring. Indeed, we are going to use the Remote Desktop for configuring the TeamCity web app and the IIS server. Remind that, when you allocate more resource (D1 or D3 for example), the Remote Desktop will be more responsive, you'll save a lot of time. Of course you could downgrade later to minimize hosting costs.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/09/createvm.jpg' caption="Quick create azure VM" %}

## creating the Azure SQL Database and server
Then you will have to create an Azure SQL Server with an SQL database. This times, on <a href="http://windows.azure.com">windows.azure.com</a>, go to Sql database and click 'Custom&nbsp;create'. For the SQL Server, choose 'new sql server'. You can select the minimal configuration: a Basic Tier with maximum size of 2GB. <strong>Important:</strong> choose <strong>Enable V12</strong> for your SQL server. Non-v12 server are not supported by TeamCity. At the time of the writing, it seems impossible to upgrade a database server to v12 after it is created, so do not forget and create a v12 instance. You will be asked to provide credentials for the administrator of the database. Keep your password, you will need it later when configuring the database settings in TeamCity.

## TeamCity installation
When it is done, connect your Azure VM using Remote Desktop. Now we are going to install TeamCity on the Azure VM. Precisely, we will install it to run under the admin account that we created when creating the VM. I strongly recommend to run TeamCity with admin privileges unless you may encounter many problematic errors.

On remote desktop VM, start Internet Explorer and visit the Jetbrains TeamCity website:&nbsp;<a href="https://www.jetbrains.com/teamcity">https://www.jetbrains.com/teamcity</a>. You may&nbsp;have to put this site as a trusted source in order to visit from IE, this is also the same for downloading the file. To change internet security settings click the gear at the right top corner of IE and then InternetOptions security etc.

Once downloaded, start the installer. You may install it almost anywhere on the VM disk, the default, <em>C:\TeamCity,</em> is fine.

On the next installation screen, you will be asked 'which component to install?'. You have to install both components Build agent and Server to have a working configuration. Indeed, in this post we will performed a basic TeamCity installation where the build agent and the continuous integration server are installed on the same machine. However keep in mind that TeamCity is a great product that enables you to distribute on several machine many build agents. They will be in charged of executing heavy builds simultaneously.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/09/agentandbuildservice.jpg' caption="Install agent and build server" %}

Later, you'll be asked for the port, <strong>set it to 8080</strong> (for example) instead of the default 80. Indeed, we do not want our TeamCity integration website being served without SSL, but serving the website through https/443 will be the topic of the next post... Finally, choose to Run TeamCity under a user account (the administrator of the vm, no need to create a new user).

After that, TeamCity server starts and an Internet Explorer window on <em>localhost:8080</em> will be opened. I will ask you the DataDirectory location on the TeamCity server machine (choose the default).

## Database configuration
Now comes the tricky thing, configuring the database. As explained in <a href="https://confluence.jetbrains.com/display/TCD9/Setting+up+an+External+Database">many places</a> by Jetbrains do not keep the internal database for your installation. To use an Azure SQL Database, choose <em>MSSQL Server</em>.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/09/databaseconnectionsettings-1024x576.jpg' caption="Database connection settings in TeamCity" %}

You will have to install je jdbc 4.0 driver that is needed by TeamCity to work with an SQL Server database. It is a very easy task that consist of putting a jar file ( sqljdbc4.jar) under the DataDirectory. It is well documented in the&nbsp;Jetbrains link. Consequently, I will just add that the default DataDirectory is an hidden folder located by default at&nbsp;C:ProgramDataJetBrainsTeamCitylibjdbc.

Now we have to fill the form for database settings. We will need the connection string that is available on the azure portal. If you select the ado.net representation, it should look like <em>Server=tcp:siul9kyl03.database.windows.net,1433;Database=teamcitydb;User ID=teamcitydbuser@siul9kyl03;Password={your_password_here};Trusted_Connection=False;Encrypt=True;Connection Timeout=3</em>0;

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/09/databaseconnectionsettings1-1024x576.jpg' caption="Entering the database connection settings." %}

If you use a connection string formatted as above. When filling the form in TeamCity, you will enter the following entries (see screensho).

Remark that you may be rejected because your SQL database server does not allow Windows Azure (then this current VM) to access it. You have to manually grant it, in Azure management portal, on the Configure menu of the SQL SERVER. Click 'yes' for allowed Windows Azure services.

Then you will meet a last step, that ask you to create an admin user for your TeamCity web application.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/09/createfinalstep-1024x576.jpg' caption="Final step! create an administrator for TeamCity web app" %}

Now, the first step&nbsp;of our installation tutorial is completed and we have a TeamCity server setup on our Azure VM. Visiting your TeamCity website on teamcityserver.cloudapp.net or even teamcityserver.cloudapp.net:8080 is not possible. Indeed,&nbsp;we setup the server on port 8080. This endpoint is blocked by your Windows Azure VM. In the next part, we will see how to serve&nbsp;properly and securely our integration web app through 443 port.

Before going to the second part. I suggest that you check your TeamCity works well locally on the VM by creating a very simple project. In our case, we create a build configuration that just checkouts source from a public github repository and perform a Powershell task that says "hello world". When triggering the build manually (run button), the build is well executed. This means that the setup of the TeamCity server is completed. Configuring its web access will be the rest of our job.

{% include image-caption.html imageurl='/assets/images/legacy-wp-content/2015/09/firstbuild-1024x576.jpg' caption="Our first build is passed" %}

PS: do not forget to downgrade the resources associated with your VM instance when you are done with configuration. There is no need to pay&nbsp;for a&nbsp;large VM if you do not need such performance.

