# Blobash
  ~ Stylesheet generator for Blobmoji with Discord, in 100% POSIX shell
***
  Blobash is built around being as portable as possible.  
  And only requires busybox utils (or GNU coreutils if ur into that)  
  As well as some kind of way to obtain the git repo, and it's submodules, such as `git`, `curl`, or even `wget` (if your into that)  
***
  Blobash was created as a `poc` (proof of concept), to prove that every lang has it's place.  
  Golang is a great lang, but generating CSS is very simple and can be done easily with a low-level scripting lang, such as POSIX sh.  

---

  the mapping.go file comes from [here](https://github.com/ThatGeekyWeeb/discordemojimap/blob/13940401e356e643b5e46e05a6b3e33011c4f899/mapping.go)

---

  CSS content was stolen from [disblob](https://github.com/diamondburned/disblob)  

[![I don't hate golang, anymore](https://github-readme-stats.vercel.app/api/pin/?username=diamondburned&repo=disblob)](https://github.com/diamondburned/disblob)
***
  Generating the CSS is very simple, and only requires `busybox` + `git`.
  ```sh
$ git clone https://github.com/ThatGeekyWeeb/blobash.git # --recursive 
# in theory --recursive would be faster, but I have no way of knowing if git will clone the master branch for the submodules
$ cd blobash
$ git clone https://github.com/ThatGeekyWeeb/discordemojimap.git ./discordemojimap
$ git clone https://github.com/C1710/blobmoji.git --depth 1 ./blobmoji
$ sh gen.sh
  ```
***
  If your annoying and just want the CSS, use the following...
```css
@import url("https://cdn.discordapp.com/attachments/699685435198144553/815166251705696266/style_part00.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/815166157375406090/style_part01.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/815167411467583528/style_part02.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/815166193563598848/style_part03.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/815167055857975296/style_part04.css");
```
