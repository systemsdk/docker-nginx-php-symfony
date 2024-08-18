# Defined in - @ line 1
function console --wraps=/var/www/html/bin/console --description 'alias console=/var/www/html/bin/console'
    /var/www/html/bin/console $argv;
end
