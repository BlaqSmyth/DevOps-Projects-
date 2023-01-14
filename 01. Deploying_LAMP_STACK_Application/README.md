# Deploying a LAMP STACK Web Application on AWS Cloud 
____
A LAMP stack is a bundle of four different software technologies that developers use to build websites and web applications. LAMP is an acronym for the operating system, Linux; the web server, Apache; the database server, MySQL; and the programming language, PHP. All four of these technologies are open source, which means they are community maintained and freely available for anyone to use. Developers use LAMP stacks to create, host, and maintain web content. It is a popular solution that powers many of the websites you commonly use today.
## Step-0 Creating Virtual Machine(EC2 Instance)
In order to complete this project you will need an AWS account and a virtual server with Ubuntu Server OS. AWS is the biggest Cloud Service Provider and it offers a free tier account that we are going to leverage for our projects.

You can watch the two videos below to set-up and connect to your EC2 instance on AWS;

1. [AWS account setup and Provisioning an Ubuntu Server](https://www.youtube.com/watch?v=xxKuB9kJoYM&list=PLtPuNR8I4TvkwU7Zu0l0G_uwtSUXLckvh&index=7)
1. [Connecting to EC2 Instance](https://www.youtube.com/watch?v=TxT6PNJts-s&list=PLtPuNR8I4TvkwU7Zu0l0G_uwtSUXLckvh&index=8)

Your instance should look like this if created properly;  
![screenshot 1](https://user-images.githubusercontent.com/57641192/212464982-786d865d-7cdd-4936-9b49-5a62420a97e4.png)

### Connecting to EC2 Terminal
There are different methods for connecting to EC2 Instance depending on your machine OS;
1. For Windows users, you will need a tool called putty to connect to your EC2 Instance. Download Putty [Here](https://www.putty.org/)
1. For Mac users, you can simply open up Terminal and use the ssh command to get into the server.

*__IMPORTANT__* – save your private key (.pem file) securely and do not share it with anyone! If you lose it, you will not be able to connect to your server ever again!

<details open>
  <summary> <b>Using the terminal on MAC/Linux</b> </summary>
<br>

* The terminal is already installed by default. You just need to open it up.
* You do not need to convert to a .ppk file. Just use the same key as downloaded from AWS.
* Change directory into the loacation where your PEM file is using the command below. Most likely will be in the Downloads folder
```bash
  cd ~/Downloads
```
* Change premissions for the private key file (.pem), otherwise you can get an error "Bad permissions"
```bash
  sudo chmod 0400 <private-key-name>.pem
```
* Connect to the instance by running
```bash
  ssh -i <private-key-name>.pem ubuntu@<Public-IP-address>
  ```
  </details>
  
*__IMPORTANT__* - Anywhere you see these anchor tags < > , going forward, it means you will need to replace the content in there with values specific to your situation. For example, If the private key you downloaded was named my-private-key.pem simply remove the anchor tags and insert my-private-key.pem in the command you are required to execute.
Congratulations! We've have successfully created our first Linux Server in the Cloud and our set up looks like this now;
![Screenshot](https://user-images.githubusercontent.com/57641192/212467119-4afdc115-52b1-413e-bbd6-649ebbcac346.png)

## Step-1 Setting-Up Apache Web Server & Updating The Firewall
The Apache web server is among the most popular web servers in the world. It’s well documented, has an active community of users, and has been in wide use for much of the history of the web, which makes it a great default choice for hosting a website.
  
To deploy the web application, we need to install Apache using Ubuntu's package manager [*__'apt'__*](https://en.wikipedia.org/wiki/APT_(software))
