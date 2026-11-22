# Overthewire

OverTheWire's Bandit wargame is designed to help people learn and practice security concepts and Linux command-line skills (Bash) through gamified challenges. 

Each level requires logging into an SSH server using credentials found in the previous level, finding a hidden flag, and using it to access the next level.

## Table of content

- [Overthewire](#overthewire)
  - [Table of content](#table-of-content)
  - [https://overthewire.org/wargames/bandit/](#httpsoverthewireorgwargamesbandit)
  - [Bandit Level 0](#bandit-level-0)
  - [Bandit Level 0 → Level 1](#bandit-level-0--level-1)
  - [Bandit Level 1 → Level 2](#bandit-level-1--level-2)




## https://overthewire.org/wargames/bandit/

```bash
ssh -p 2220 bandit0@bandit.labs.overthewire.org

# bandit0

```

## Bandit Level 0

```bash
bandit0@bandit:~$ pwd
/home/bandit0

bandit0@bandit:~$ ls
readme

```

## Bandit Level 0 → Level 1

The password for the next level is stored in a file called readme located in the home directory. Use this password to log into bandit1 using SSH. Whenever you find a password for a level, use SSH (on port 2220) to log into that level and continue the game.

```bash

ssh -p 2220 bandit0@bandit.labs.overthewire.org

# bandit0

cat readme

# The password for the next level is stored in a file called readme located in the home directory.

grep '6y*' readme 
The password you are looking for is: 6y2kwnwK6grgvwvpvLaa2T1cpFEKOhNR

exit

```

## Bandit Level 1 → Level 2

The password for the next level is stored in a file called - located in the home directory

```bash

ssh -p 2220 bandit1@bandit.labs.overthewire.org

bandit1@bandit:~$ ls
total 24K
-rw-r-----   1 bandit2 bandit1   33 Oct 25 13:37 -

# Just file - ?
-

# How can you tell a command to treat an argument strictly as a path inside the current directory?
cat ./-
PK8fYLZg2hnHSz83plBL1iEPKdD3QToB
``` 


## Bandit Level 2 → Level 3

The password for the next level is stored in a file called --spaces in this filename-- located in the home directory

```bash

ssh -p 2220 bandit2@bandit.labs.overthewire.org


bandit2@bandit:~$ ls
--spaces in this filename--

cat "./--spaces in this filename--"
7ZZ2LFrykP2zEyvBl4m3clcL7tGYJPME


```

## Bandit Level 3 → Level 4

The password for the next level is stored in a hidden file in the inhere directory.


```bash

ssh -p 2220 bandit3@bandit.labs.overthewire.org

bandit3@bandit:~$ ls
inhere

``