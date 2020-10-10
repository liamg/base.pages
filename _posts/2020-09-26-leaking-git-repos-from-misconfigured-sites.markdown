---
layout: post
title:  "Leaking Git Repositories From Misconfigured Sites"
date:   2020-09-26 12:53:48 +0100
categories: security
---
Many deployment mechanisms for web applications exist in which the contents of a repository is copied onto a production server, whether this is by building the files into a Docker container, or simply transferring them directly onto a webserver. This can often result in the publishing of sensitive files such as CI configs, READMEs, and the one we're going to focus on today: .git directories. 

A .git directory stores all of your repository data, such as configuration, commit history, and actual content of each file in the repository. If you can retrieve the full contents of a .git directory for a given website, you will be able to access raw source code for that site, and often juicy configuration data like database passwords, password salts, and more. 

Webservers with directory listings enabled make this kind of attack especially easy, as it's simply a matter of recursively downloading every file in the .git directory and running the following to pull files from the stored object files:

{% highlight bash %}
git checkout -- .
{% endhighlight %}
 
You can typically achieve the recursive download with 

{% highlight bash %}
wget --np -r http://TARGET/.git/
{% endhighlight %}

The attack is still possible when directory listings are disabled, but it's often difficult to retrieve a complete repository in such cases. This is where [gitjacker](https://github.com/liamg/gitjacker) comes in. Gitjacker will handle the download and extraction of a git repository for you.

![gitjacker demo](https://raw.githubusercontent.com/liamg/gitjacker/master/demo.gif)

It works by looking for common Git paths such as `.git/config`, and parsing references to other files from these, essentially spidering the repository and retrieving everything which is discovered.

You can download the latest release [here](https://github.com/liamg/gitjacker/releases).
