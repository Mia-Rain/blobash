# Blobash
  ~ Stylesheet generator for Blobmoji with Discord, in 100% POSIX shell
***
  Blobash's test build was preformed using `dash`, with busybox coreutils.\
  If we simply want to test this project you can simply inject this JS
  ```js
["https://cdn.discordapp.com/attachments/699685435198144553/786841908126810122/style_part00.css","https://cdn.discordapp.com/attachments/699685435198144553/786841908173078528/style_part01.css","https://cdn.discordapp.com/attachments/699685435198144553/786841903848488960/style_part02.css","https://cdn.discordapp.com/attachments/699685435198144553/786841904209461278/style_part03.css","https://cdn.discordapp.com/attachments/699685435198144553/786840312185487380/style_part04.css"].forEach(function(i) {
    var link = document.createElement("link");
    link.href = i;
    link.type = "text/css";
    link.rel = "stylesheet";
    document.getElementsByTagName("head")[0].appendChild(link);
});
  ```
  or this CSS
  ```css
@import url("https://cdn.discordapp.com/attachments/699685435198144553/786841908126810122/style_part00.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/786841908173078528/style_part01.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/786841903848488960/style_part02.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/786841904209461278/style_part03.css");
@import url("https://cdn.discordapp.com/attachments/699685435198144553/786840312185487380/style_part04.css");
  ```
***
  Blobash was created as a `poc` (proof of concept), to show that using golang for scripted actions is overkill.\
  The process for generating the CSS was stolen from [disblob](https://github.com/diamondburned/disblob) (Which is written in golang :rage:)
[![](https://github-readme-stats.vercel.app/api/pin/?username=diamondburned&repo=disblob)](https://github.com/diamondburned/disblob)
***
  Generating the CSS is very simple, and only requires `busybox` + `git`.
  ```sh
$ git clone https://github.com/ThatGeekyWeeb/blobash
$ git submodule update --init
$ sh gen.sh # export 'update=no' to disable requirement of curl or wget
  ```
