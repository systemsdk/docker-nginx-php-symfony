# This file is part of the Symfony package.
#
# (c) Fabien Potencier <fabien@symfony.com>
#
# For the full copyright and license information, please view
# https://symfony.com/doc/current/contributing/code/license.html

function _sf_console
    set sf_cmd (commandline -o)
    set c (count (commandline -oc))

    set completecmd "$sf_cmd[1]" "_complete" "--no-interaction" "-sfish" "-a1"

    for i in $sf_cmd
        if [ $i != "" ]
            set completecmd $completecmd "-i$i"
        end
    end

    set completecmd $completecmd "-c$c"

    $completecmd
end

complete -c 'console' -a '(_sf_console)' -f
