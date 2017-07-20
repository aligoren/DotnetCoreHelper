PROJECT_DIRECTORY=${PWD##*/}

create_controller()
{
cat << EndOfController > "Controllers/$1Controller.cs"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace $PROJECT_DIRECTORY.Controllers
{
    public class $1Controller : Controller
    {
        public ActionResult Index()
        {
            return View();
        }
    }
}
EndOfController

mkdir -p "Views/$1"

cat <<EndOfControllerView  > "Views/$1/Index.cshtml"
@{
    ViewData["Title"] = "$1";
}
<h2>@ViewData["Title"].</h2>

<p>Welcome this page is your $1's Index Page</p>
EndOfControllerView

}

read_controller()
{
    process_line=$(head -n -2 Controllers/$1Controller.cs)
    rm "Controllers/$1Controller.cs"


    method_name="$2"
    type="$3"

    method=$'\n\n'
    method+=$'\t\t'"public $type $method_name()"
    method+=$'\n\t\t{\n'
    method+=$'\t\t\treturn View();';
    method+=$'\n\t\t}'
    method+=$'\n\t}\n'
    method+="}"

    process_line+="$method"

    echo "$process_line" >> "Controllers/$1Controller.cs"
    
    mkdir -p "Views/$1"
    echo -n > "Views/$1/$method_name.cshtml"

cat <<EndOfControllerView  > "Views/$1/$method_name.cshtml"
@{
    ViewData["Title"] = "$2";
}
<h2>@ViewData["Title"].</h2>

<p>Welcome this page is your $2's Index Page</p>
EndOfControllerView

}

ARGC=$#

while [[ $# -gt 0 ]] ; do
    case $1 in
        -c|--create)
            if [ -n "$2" ]; then
                create_controller "$2"
            fi
            ;;
        -am|--add-method)
            if [[ $ARGC == 4 ]]; then
                read_controller "$2" "$3" "$4"
            fi
            ;;
    esac
    shift
done