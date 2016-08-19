
███╗   ███╗██╗   ██╗██╗  ████████╗██╗███████╗██╗  ██╗██╗   ██╗██████╗ ███████╗
████╗ ████║██║   ██║██║  ╚══██╔══╝██║██╔════╝██║ ██╔╝╚██╗ ██╔╝██╔══██╗██╔════╝
██╔████╔██║██║   ██║██║     ██║   ██║███████╗█████╔╝  ╚████╔╝ ██████╔╝█████╗  
██║╚██╔╝██║██║   ██║██║     ██║   ██║╚════██║██╔═██╗   ╚██╔╝  ██╔═══╝ ██╔══╝  
██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║███████║██║  ██╗   ██║   ██║     ███████╗
╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚══════╝
                                                                              
===============================================================================

Table of Contents
-----------------

I. Introduction

II. How to Setup/Use

   i. Windows
      1. Adding Accounts and Encryption
      2. Running MultiSkype

   ii. Linux
      1. Adding Accounts and Encryption
      2. Running MultiSkype
      3. (Optional) Setting up the .desktop file

III. Credits


=======================================================

I. Introduction

Maintaining two or more Skype accounts can be a pain - autologin breaks when 
you do, and logging in manually to multiple accounts is tedious.

This software was designed to do exactly that - With MultiSkype, you can 
finally log into multiple accounts with just one password, and get access 
through a convenient little .sh (bash script) or .exe (Windows executable)! 
With this, you can set it at startup, open it manually, whatever you want.
Go crazy.

Technical Details: MultiSkype grabs your account information, encrypts it with
a master key provided by the user, and decrypts it at login. 


II. How to Setup/Use

i. Windows


1. Adding Accounts and Encryption

First off, you will need to set up the application with your account details. 
Run MultiSkype (Encryption).exe and follow the instructions. 

2. Running MultiSkype

Simply run MultiSkype (Login).exe, and provide the master key you encrypted
your accounts with earlier. Due to the nature of the program, you risk breaking 
the flow of the program if you click around.


ii. Linux


1. Adding Accounts and Encryption

First off, you will need to set up the application with your account details. 
Run generateauthenc.sh from bash and follow the instructions.

2. Running MultiSkype

Simply run skypelogin.sh from the bash shell, and provide the master key you
encrypted your accounts with earlier. Should be clean running from there.

3. (Optional) Setting up the .desktop file

For your convenience, I wrote a multiskype.desktop file you can use. You will
need to edit the Path, Exec, and Icon variables, to the MultiSkype directory,
.sh filepath, and icon filepath respectively (icon located in the img folder).
Some of it is filled in for you, so it should just be a matter of completing
the filepath.

More info here: http://askubuntu.com/questions/60667/apply-icons-to-bash-scripts


III. Credits

Thanks to patorjk and his ASCII text generator, at patorjk.com/software/taag. 
Font used in title: ANSI Shadow

Please contact me about any bugs or questions, at: admin@sunquyman.xyz
Follow me on Github! https://github.com/Sunquyman
And visit me at: sunquyman.xyz

-Sunquyman
