# Learn Bash

The goal of this document is to teach you some of the basics of shell scripting with `bash`.


First off, what is a *shell* and what is `bash`?
A shell is a interactice command line interpreter. 
`bash` stands for "Bourne Again Shell" and it is one of many UNIX like shells, other examples being `sh`, `ksh` and `zsh`.

There is a lot overlap between these different UNIX shells and many of the commands that work the same way in one shell will also work in the other shells.
The shells differ in some small ways that you hopefully won't enconter as a beginner.
In generall though, `sh` is less fully featured than `bash` which is less fully featured than `zsh`.
`zsh` is the default shell on Macs.

`PowerShell` and `cmd` are examples of Windows/DOS shells, which I might cover later, but for now they are out of the scope of this document.

## Chaining Commands

In this section we will cover how to chain or "pipe" together multiple shell commands to do something more useful than we can achive with a single command.
I will assume you have a basic familiarty with the following commands:

- `ls` - lists contents of directory
- `pwd` - prints current directoy
- `cd` - changes directory
- `touch` - create a file
- `mkdir` - create a file


In bash (and other shells) we can send the output of one command to be the input of another command.
We do this by placing a pipe `|` character between the two commands.

Try the example below. This combination of commands will list the contents of the current directory and print the name of any file that ends with the extension `.csv`.

```shell
ls -1 | grep *.csv
```

The command `grep` is like the "Ctrl+F" of command line tools. 
`grep` stands for "Global Regular Expressions search and Print".
This command will search through whatever input it is given one line at a time and print out any line that matches the pattern provided.

> Regular expressions are a complex topic unto themselves.You can read more here: https://regexlearn.com/learn/regex101

We can also pipe together more than one command, like we do in the following example:

```shel
cat samplefile.txt | sort | uniq 
```

This example prints out each unique line in the file `samplefile.txt`.
Lets explain the commands here:
- `cat` short for "concatenate" prints the countents of of a file to the console
- `sort` sorts all the lines in its input (in this case it sorts alphabetically)
- `uniq` removes duplicate lines from its input

You might be wondering why we need to use the `sort` command if there is alreayd a command called `uniq`.
You can try removing the call to `sort` or reversing the order and you will see that we do not get the desired result.
This is due to a somewhat weird quirk of the `uniq` command. 
This command only compares lines to the previous lines in the input.
Meaning if there are two identical lines that are not adjacent, the duplicate line will not be removed by this command.
This is why you will often see these two commands used in tandem.

## Saving the Output of Commands

We have now seen how to combine different commands using pipes, but how can we use the output of our commands without having to run them again?

In bash we can use the `>` character to redirect the output of our command to a file. This single arrow will create a new file if one does not exist and overwrite an existing file.
In the following example we use the `head` command which prints the first 10 lines (by default) of a file and then save those 10 lines in a new file called `first_10_lines.txt`


```shell
head longfile.txt > first_10_lines.txt
```

We can also use two `>>` characters to append some text to a file.
This is usually used when you are using a script with some sort of loop, so we will come back to this.

## `stdin`, `stdout` and `stderr`

In the previous two sections I have been using the generic terms "input" and "output", but to be more specific shell commands have the following communication channels: Standard Input (`stdin`), Standard Output (`stdout`) and Standard Error (`stderr`)

So to be more precise the `|` character redirects the `stdout` of the left command to the `stdin` of the right command.

> As an aside, in Java the standard streams can be accesed under the `System` package using: `System.in`, `System.out` and `System.err`

### What is `stderr`?

---

`stderr` is a second type of output channel that is used for error messages when a command encounters an issue. 
It is most often used in bash scripts in a pattern where error messages are redirected to one file and normal log messages are redirected to another file.

An example of this is shown in the snippet below.
After running this short script you should see a file called "err.txt" that contains the text "I'm going to stderr" and a file called "log.txt" that contains the line "I'm going to stdout".

```shell
$ ./std.sh 2> err.txt > log.txt
```

### What is `/dev/null`

---

If you are running a script and you don't care about the error messages you can use this other common pattern:

```shell
$ ./std.sh 2> /dev/null
I'm going to stdout
```

This command will redirct the `stderr` to `/dev/null` which is a standard Linux device file (in linux everything is treated like a file) that simply ignores whatever input is passed to it. 

### What is `2>&1` and `&>`

---

One last common pattern you might see is `&>` or `2>&1`.
These two redirctions achieve the same goal of redirecting the `stderr` of a command to the same place as the `stdout` of the command.

After running either snippet below you should see a text file called "log_and_err.txt" that contains both lines of text echoed in the "std.sh" script.

```shell
$ ./std.sh &> log_and_err.txt
$ ./std.sh > log_and_err.txt 2>&1
```


## Exist Statuses

We have just seen how to redirect the output of a script during normal execution and during an error state, but what if a script doesn't print anything to `stdout` or `stderr`? 
How can we tell if the script was succesful? 
We can use **Exit Statuses** (aka return codes or exit codes), which you might be familiar with from other branches of programming.

When a command or script finishes running succesfully it will return a status of `0` to the parent process. 
If the command or script encounters some sort of error it will return a non-zero exit code to the parent process.

We can check the exit status of a command by printing the value of the special parameter `$?` to the console.
In the snippet below I try to run a command that does not exist, which returns the exit code `127`. 

```shell
$ somecommand
bash: somecommand: command not found

$ echo $?
127
```

On its own this special variable (`$?`) might not seem very useful, but it can be helpful in writing custom scripts or conditionals (which we will cover later).

### The Operators: `&&` and `||`

We can also use the exit status of a command in a more usefull way by taking advantage of the operators: `&&` and `||`

Similar to the `|` operator, these two operators are used to chain multiple commands together.
Where as the single-pipe is unconditional the other two only execute the following command if a certain exit code is returned from the command.
The command after `&&` will only execute if the exit code of previous command is `0`
The command after `||` will only execute if the exit code of the previous command is not zero.

In the snippet below we can see these operators in action:

```shell
$ echo "hi" && echo "success!" || echo "failure!"
hi
success!

$ somecommand && echo "success!" || echo "failure!"
bash: somecommand: command not found
failure!
```






## Customizing Your Shell

So far we've learned some usefull commands and how to combine them in interesting ways, but what if we don't like typing that much?
That is where the `alias` command comes in.

### Alieses

As you might have guessed this command lets you create an alias or alternate name for a shell command.
For example I often want to use `ls -lrt` so I create an alias for it in all my setups.

> With the `ls` command the `-l` flag indicates you want the long, detailed format of each file, `-r` means you want the files sorted in reverse order and `-t` means you want the files sorted by modification time

We can create a shorthand version of this command by running the following:

```bash
$ alias ll="ls -lrt"

$ ll
total 19
-rw-r--r-- 1 NAEAST+O765489 4266656257   19 Jun 26 13:03 sample.csv
-rw-r--r-- 1 NAEAST+O765489 4266656257   38 Jun 26 13:27 samplefile.txt
-rw-r--r-- 1 NAEAST+O765489 4266656257 3462 Jun 26 13:45 longfile.txt
-rw-r--r-- 1 NAEAST+O765489 4266656257  468 Jun 26 13:46 first_10_lines.txt
-rwxr-xr-x 1 NAEAST+O765489 4266656257   73 Jun 27 07:48 std.sh
-rw-r--r-- 1 NAEAST+O765489 4266656257   20 Jun 27 07:49 log.txt
-rw-r--r-- 1 NAEAST+O765489 4266656257   20 Jun 27 07:49 err.txt
-rw-r--r-- 1 NAEAST+O765489 4266656257   40 Jun 27 08:02 log_and_err.txt
-rw-r--r-- 1 NAEAST+O765489 4266656257 6597 Jun 27 08:51 learn-bash.md

```

This is great but if you close out of your shell and try running `ll` again you'll see the following:

```bash
$ ll
bash: ll: command not found
```

This is because the `alias` command only lasts for the current shell session. 
In order to make this change permanent we need to learn about `.bashrc` and `.bash_profile` files.

### Profiles

> For more see: https://linuxize.com/post/bashrc-vs-bash-profile/






## Standalone Scripts (TODO)

## Conditional Logic (TODO)

## Loops (TODO)