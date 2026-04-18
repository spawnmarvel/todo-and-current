# Countries

Countries

Inspired by https://web.mit.edu/mprat/Public/web/Terminus/Web/main.html

Fly to countries from home
It might not be direct flights to your destination, then select a valid destination
You might be stopped by customs or other's on your travell
As you travell, you can store notes in your notebook, you might need them for later

Real linux commands are used so this is game for learning bash and countries.
It’s not just a game about geography; it’s a CLI (Command Line Interface) Simulator.
Type m for menu

## Verify file


If the script on GitHub looks exactly like what you pasted, then the error bash: line 116: syntax error near unexpected token '(' is almost certainly caused by hidden non-ASCII characters (specifically "Gremlins" like non-breaking spaces) that got into the file during a copy-paste or a save.

Your file is likely saved in UTF-8 with BOM or has Mac/Windows line endings, but the shell environment is expecting pure UTF-8/ASCII.

Check the main.sh first

Test the script locally WITHOUT the pipe

```bash
bash -n main.sh

```
The -n flag stands for "noexec." It will read the script and check for syntax errors without actually running it. If it returns nothing, your syntax is clean!

Option A: The sed Surgery (Recommended)
This command strips the hidden Windows carriage returns (\r) and saves the file back to itself.

```bash
sed -i 's/\r//' main.sh
``` 

## 🚀 Play Countries Now!


Copy and paste this into your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/spawnmarvel/todo-and-current/main/bash/games/countries/main.sh | bash
```
This makes the "barrier to entry" almost zero. It’s clean, it’s professional, and it’s how the biggest tools in the world (like Docker or Rust) handle their installers.

💡 Why /dev/tty is the "Pro" Move

In Linux, /dev/tty is a special file that represents the terminal device currently being used. By pointing your read command there, you are effectively "reaching around" the curl stream to grab the user's keystrokes directly.



## 🛠️ Turning your GitHub into a "Playground"

To make it "World Famous," you should add a "Play in Browser" button to your GitHub README.

Go to MyBinder.org

Enter your GitHub URL.

They will give you a "Badge" (a little image button).

Paste that badge into your README.

Now, when a user clicks that button, a browser tab opens, a terminal starts up, and your game begins automatically.

## Version


Version 1.2

* 
* 