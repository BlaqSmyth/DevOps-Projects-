# Deploying a LAMP STACK Web Application on AWS Cloud 
____
A LAMP stack is a bundle of four different software technologies that developers use to build websites and web applications. LAMP is an acronym for the operating system, Linux; the web server, Apache; the database server, MySQL; and the programming language, PHP. All four of these technologies are open source, which means they are community maintained and freely available for anyone to use. Developers use LAMP stacks to create, host, and maintain web content. It is a popular solution that powers many of the websites you commonly use today.
## Step 0 - Creating Virtual Machine(EC2 Instance)
In order to complete this project you will need an AWS account and a virtual server with Ubuntu Server OS. AWS is the biggest Cloud Service Provider and it offers a free tier account that we are going to leverage for our projects.

You can watch the two videos below to set-up and connect to your EC2 instance on AWS;

1. [AWS account setup and Provisioning an Ubuntu Server](https://www.youtube.com/watch?v=xxKuB9kJoYM&list=PLtPuNR8I4TvkwU7Zu0l0G_uwtSUXLckvh&index=7)
1. [Connecting to EC2 Instance](https://www.youtube.com/watch?v=TxT6PNJts-s&list=PLtPuNR8I4TvkwU7Zu0l0G_uwtSUXLckvh&index=8)

Your instance should look like this if created properly;

![Image-1](https://user-images.githubusercontent.com/57641192/212464982-786d865d-7cdd-4936-9b49-5a62420a97e4.png)

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
*__IMPORTANT__* - Anywhere you see these anchor tags < > , going forward, it means you will need to replace the content in there with values specific to your situation. For example, If the private key you downloaded was named my-private-key.pem simply remove the anchor tags and insert my-private-key.pem in the command you are required to execute.
  </details>
  

Congratulations! We've have successfully created our first Linux Server in the Cloud and our set up looks like this now;
  
![Image-2](https://user-images.githubusercontent.com/57641192/212467119-4afdc115-52b1-413e-bbd6-649ebbcac346.png)

## Step 1 - Setting-Up Apache Web Server & Updating The Firewall
The Apache web server is among the most popular web servers in the world. It’s well documented, has an active community of users, and has been in wide use for much of the history of the web, which makes it a great default choice for hosting a website.
  
To deploy the web application, we need to install Apache using Ubuntu's package manager [*__'apt'__*](https://en.wikipedia.org/wiki/APT_(software))
```bash
  #update a list of packages in package manager
  $ sudo apt update

  #run apache2 package installation
  $ sudo apt install apache2
```
To verify that Apache2 is running as a Service in our OS, use following command;
  ```bash
    $ sudo systemctl status apache2
  ```
If everything is green and running just like the image below - we have just launched our first Web Server in the Clouds!

![Image-3](https://user-images.githubusercontent.com/57641192/212469600-389fcba5-2571-42a6-a5ee-f1264f06d3f9.png)
  

### Configuring Security Group(FireWall) Inbound Rules On EC2 Instance
A Security Group is a group of rules that acts as a virtual firewall to the type of treffic that enters(inbound traffic) or leaves(outbound traffic) our server.
  
Before we can receive any traffic by our Web Server, we need to open TCP port 80 which is the default port that web browsers use to access web pages on the Internet. As we know, we have TCP port 22 open by default on our EC2 machine to access it via SSH, so we need to add a rule to EC2 configuration to open inbound connection through port 80: as shown in the image below;
  
![Image-4](https://user-images.githubusercontent.com/57641192/212470320-f46cf99e-49c4-46d0-8af0-8d1af2f5ca78.png)
  
To check the accessiblity of our web server on the internet, we curl the IP address/DNS name of our localhost using either of the commands below;
```bash
  $ curl http://localhost:80
or
  $ curl http://127.0.0.1:80
```
  
Finally, to see if our web application server can respond to requests over the internet - open a web browser and try to access the Public IP of our EC2 Instance.
```bash
  http://<Public-IP-Address>:80
```
  
*__Note__* : We can also retrieve our Public IP Address using our Ubuntu Terminal other than the AWS Console using the following commands;
  ```bash
    $ curl -s http://169.254.169.254/latest/meta-data/public-ipv4
```
If you see following page, then your web server is now correctly installed and accessible through your firewall over the internet. 
  
![Image-5](https://user-images.githubusercontent.com/57641192/212470894-7a249cdf-1908-4e01-bcf5-0405ed12a983.png)
  
## Step 2 - Installing MySQL
  
MySQL is a popular relational database management system used within PHP environments, so we will use it in our project.
  
Again, use the ‘apt’ package manager to acquire and install MySQL;
```bash
  $ sudo apt install mysql-server
```
  
You should get the request as shown in the image below and confirm 'Y' to proceed with installation

![Image-7](https://user-images.githubusercontent.com/57641192/212471434-94be6df8-fab2-4cb1-864d-29e7b6dfb160.png)

Use the ``` sudo mysql_secure_installation``` command to remove insecure default settings and enable protection for the database.

![Image-9](https://user-images.githubusercontent.com/57641192/212502009-c5cd9f74-9d91-45ca-b80b-28ec4de7880d.png)
  
When the installation is finished, log in to the MySQL console with the command below;
``` $ sudo mysql ```
  
![Image-9](https://user-images.githubusercontent.com/57641192/212502140-3a3a282f-5013-4bb8-bc60-157835e9b412.png)
  
If you get the imaga above then you've successfully logged into the MySQL console. Then exit the MySQL shell using the following command ``` exit ```
  
*__Note__*: For increased security, it’s best to have dedicated user accounts with less expansive privileges set up for every database, especially if you plan on having multiple databases hosted on your server.
  
## Step 3 - Installing PHP and Its Modules 
PHP serves as a programming language which is useful for dynamically displaying contents of the webpage to users who make requests to the webserver.

We need to install php alongside its modules, ```php-mysql``` which is a php module that allows php to communicate with the mysql database and ```libapache2-mod-php``` which ensures that the apache web server handles the php contents properly.

To install these 3 packages at once, run:

```$ sudo apt install php libapache2-mod-php php-mysql```
  
Once the installation is complete, you can run the following command to confirm your PHP version:
```php -v```
And you should get a display just like the images below;
  
![Image-10](https://user-images.githubusercontent.com/57641192/212502571-151906e2-52d6-40d7-abe6-9f02ed664895.png)
  
At this point, our LAMP stack is completely installed and fully operational.

* Linux (Ubuntu)
* Apache HTTP Server
* MySQL
* PHP
  
The next step is to set-up Apache Virtual Host to hold our website files and folders. 
  
## Step 4 - Creating A Virtual Host For Our Website Using Apache 
  
Next we set up a virtual host using apache to enable us deploy our webcontent on the webserver. Apache's virtualhosting ensures that one or more websites can run on a webserver via different IP addresses.

![Image-11](https://user-images.githubusercontent.com/57641192/212503097-3958418e-9576-4073-9805-81c4254e4195.png)

Apache webserver serves a website by the way of server blocks inside its **/var/www/** directory, and it can support multiple of this server blocks to host other websites.

Here we create a new directory called **projectlampstack** inside the **/var/www/** directory.

```sudo mkdir /var/www/projectlampstack```

Then we change permissions of the **projectlampstack** directory to the current user system

```sudo chown -R $USER:$USER /var/www/projectlampstack```
  
The **projectlampstack** directory represents the directory which will contains files related to our website as it represents a new server block on the apache webserver. In order to spin up this server block we need to configure it by creating a **.conf file.**

```sudo vi /etc/apache2/sites-available/projectlampstack.conf```

The following represents the configuration needed to spin up the server block. Copy and paste into the editor:
  
```<VirtualHost *:80>
    ServerName projectlamp
    ServerAlias www.projectlamp 
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/projectlamp
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
  
Run ```esc :wq```  to save and terminate vi editor.

Run ```sudo a2ensite projectlampstack``` to activate the server block.

Run ```sudo a2dissite 000-default``` to deactivate the default webserver block that comes with apache on default.

Reload the apache2 server the command ```sudo systemctl reload apache2```
  
Our new website is now active, but the web root **/var/www/projectlamp** is still empty. Create an **index.html** file in that location so that we can test that the virtual host works as expected. Input the block of code below in the **index.html** file:
  
```sudo echo 'Hello LAMP from hostname' $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP' $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/projectlamp/index.html```
  
Now let's try to access our website from the internet using our Public IP Address:
  
```http://<Public-IP-Address>:80```
  
If you get this image below, then your Apache virtual host is working as expected.
  
![Image-12](https://user-images.githubusercontent.com/57641192/212504126-5544ae19-49aa-46fa-a8fa-96b7a4997e5a.png)

## Step 5 - Enable PHP On The Website 
With the default **DirectoryIndex8** settings on Apache, a file named **index.html** will always take precedence over an **index.php** file. This is useful for setting up maintenance pages in PHP applications, by creating a temporary **index.html** file containing an informative message to visitors. 

To serve an **index.php** containing the server-side code, you’ll need to edit the **/etc/apache2/mods-enabled/dir.conf** file and change the order in which the **index.php** file is listed within the **DirectoryIndex** with the following command and code below:
  
```sudo vim /etc/apache2/mods-enabled/dir.conf```
  
```
<IfModule mod_dir.c>
        #Change this:
        #DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
        #To this:
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
```
After saving and closing the file, you will need to reload Apache so the changes take effect:

```sudo systemctl reload apache2```

Finally, we will create a PHP script to test that PHP is correctly installed and configured on your server.
  
Create a new file named index.php inside your custom web root folder:

```vim /var/www/projectlamp/index.php```
  
This will open a blank file with vim editor. Add the following text, which is valid PHP code, inside the file:

```
<?php
phpinfo();
```
 
Now, save and close the file, refresh the our web page and we'll get the image below:

![Image-13](https://user-images.githubusercontent.com/57641192/212751272-0a8c28e0-97e5-48bf-b1d4-dd0c8d48ca22.png)
