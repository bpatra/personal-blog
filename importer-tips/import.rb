require "jekyll-import";

JekyllImport::Importers::WordPress.run({
    "dbname"         => "benblog",
    "user"           => "root",
    "password"       => "my-secret-pw",
    "host"           => "docker.for.mac.localhost",
    "port"           => "3306",
    "socket"         => "",
    "table_prefix"   => "wp_",
    "site_prefix"    => "",
    "clean_entities" => true,
    "comments"       => true,
    "categories"     => true,
    "tags"           => true,
    "more_excerpt"   => true,
    "more_anchor"    => true,
    "extension"      => "html",
    "status"         => ["publish"]
})