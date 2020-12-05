import glob
import os

all_content=""
for post in glob.glob('/Users/benoitpatra/Code/blog-perso/_posts/*.html'):
    with open(post, 'r') as file:
        all_content = all_content + file.read().replace('\n', '')

for image_pth in glob.glob('/Users/benoitpatra/Code/blog-perso/assets/images/legacy-wp-content/**/*.*', recursive=True):
    file_name = os.path.basename(image_pth)
    if file_name in all_content:
        print(f"{file_name} used somewhere")
    else: 
        print(f"{file_name} never used, deleting it!")
        os.remove(image_pth)