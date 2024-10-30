# Arbitrary File Upload

An example exploit for the vulnerability in the `Socket.io-file 2.0.31` npm package.

## Basic Introduction to Socket.io-file

The `Socket.io-file` npm package is a library that supports file upload functionality. It can be used to create an endpoint for users of a website to upload their files. The library can customize the size of uploaded files, their names, their types, etc.

## How to Start the Vulnerable Component

The vulnerabble component is provided as a docker image. You first need to build the image and then run it.

### How to Build the Vulnerable Component Image
To build the image, you should go to the `vulnerable-component` directory and then build it as follows:
```
cd vulnerable-component
docker build -t socket-io-file-vul .
```

### How to Run the Component on a Container

To run the vulnerable component propertly, you should map ports 3000 and 22 as follows:
```
docker run --rm -p 3000:3000 -p 2022:22 socket-io-file-vul
```

### The Content of the Vulnerable Component

The vulnerable component is a node.js website. After running the component, the main page of the website is accessible at `http://localhost:3000`.

The website is supposed to belong to the army of the country CATS. The army is hiring new soldiers. The website uses `Socket.io-file` to allow youths upload their CVs and get recruited!

The website also has a nice gallery of its soldiers served as static files in the `vulnerable-component/public` directory. Once the component is running, you can access one of the images on `http://localhost:3000/cat.jpg`.

### Background Theory of the Exploit

When using `Socket.io-file` to upload a file, you can also set the name of the file you are uploading. This makes a lot of sense. The big issue is that instead of passing the file name, you pass an arbitrary path! If you do so, the file will be saved in the path you have mentioned. This means the this node js package does not validate the paths passed by users.

By default, the uploaded files are supposed to be saved in the `cv-applicants` directory (see [this line](https://github.com/khaes-kth/socket.io-file-vul-ex/blob/main/vulnerable-component/server.js#L32)). However, if you pass a name like `../public/filename.html`, it will be saved in the `public` directory. Note that files in this directory are served as static files. What if a malicious actor upploads a WAR ANNOUNCEMENT to that directory? Let's see what happes below.

Even worse, users of the website can go well beyond the website's directory by setting a path like `../../../../../../{many_more_../}/root/`. Such a path gives the user write access to the files of the `root` user. This means the website users, who are supposed to have access to a specific directory, can exploit the `Socket.io-file` vulnerability to expand their access to protected files. This opens the door to many different malicious behaviors, two of which we review in this demo as follows.

### Potential Fix for the Exploit

To fix this issue, the developers of `Socket.io-file` have to simply validate the passed file name does not set the path. This can be simply done with a regex.

## How to Conduct the Attacks

### Website Defacement

After you run the vulnerable component on a container, you can simply exploit it using the `exploit_website.py` script. As input, you must pass it the ip and port of the recruitment website as well as the name of a victim country you want to announce an invasion of (!!) as follows:

```
python exploit_website.py localhost 3000 DOGS
```

This script sends a file to the website and sets its name to `../public/announcements.html`. The content of the file is a declaration of war on the country DOGS! After the file is uploaded, anyone looking at the recruitment website of the country CATS' army at `http://localhost:3000/announcements.html` thinks the CATS have declared war on DOGS!

#### Screencast Demo of Website Defacement

You can download the screencast demo [here](https://github.com/khaes-kth/socket.io-file-vul-ex/raw/refs/heads/main/demo.webm).

### Remote Access Through Altering SSH Kyes

In our second exploit demo, which is significantly more threatening, we get ssh access to the website host. In this attack, we use the vulnerability to add our local public ssh-key to the `authorized_keys` file. This give us ssh access to the host. For this, you should run the following script:

```
python exploit_ssh.py localhost 3000 {public-key-str}
```

This script saves our public ssh-key to the `/root/.ssh/authorized_keys` file. Note that you have to copy your public ssh-key file from your local `~/.ssh/{key-name}.pub` file. If you do not have such a file, follow the instructions in [this link](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04) to create one. Next, you can ssh to the host with the following command:

```
ssh root@localhost -p 2022
```

After getting ssh access to the host, you can find a flag file with running an `ls` command.

#### Screencast Demo of SSH Access

After following the instructions discussed in [Screencast Demo of Website Defacement](#screencast-demo-of-website-defacement), you can follow the demo in [this link](https://github.com/khaes-kth/socket.io-file-vul-ex/raw/refs/heads/main/ssh_demo.webm) to see how you can get ssh access and find the flag using the `Socket.io-file` vulnerability.

### Exploit Requirement

To run the exploit scripts, you have to install the socketIO-client-nexus package. If you do not have it on your system, execute the following commands before executing the exploit scripts:

```
python -m venv .venv
source .venv/bin/activate
pip install socketIO-client-nexus==0.7.6
```

## References
- [Socket.io-file 2.0.31 - Arbitrary File Upload](https://www.exploit-db.com/exploits/48713)
- [Socket.io-file 2.0](https://www.npmjs.com/package/socket.io-file)
- [Example for using Socket.io-file](https://github.com/rico345100/socket.io-file-example)
