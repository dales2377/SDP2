# Environment requirement 
1. mysql5.7
2. jdk1.8
3. nodejs 14 | 16

# How to running backend system 
1. Download and unzip thses code in you want.
2. Right click program folder, and choose " open this folder as IDEA project
   <img width="1270" alt="image" src="https://github.com/dales2377/SDP2/assets/96338681/ce8192b6-8ae6-4cbd-bc06-1ed8988a9d37">

3. After open the folder, load Maven build script.
 ![image](https://github.com/dales2377/SDP2/assets/96338681/58a5fe9a-99e8-4866-90bc-1a1ae3241002)
4. Open Terimal in IDEA, execute these code
```
cd vue

npm i

```
that will install the modules used in this project.
<img width="1280" alt="image" src="https://github.com/dales2377/SDP2/assets/96338681/70e91a09-f0f6-4f7c-966c-c1db1e0e1315">

5. Find Run/Debug configuration, add springboot running configuration。
   <img width="1280" alt="image" src="https://github.com/dales2377/SDP2/assets/96338681/3bd76723-85f9-416d-8d39-d012dfacf8ff">

6. Add npm running configuration for vue
   <img width="1280" alt="image" src="https://github.com/dales2377/SDP2/assets/96338681/ea5ac606-094b-4002-b0c9-8b9c43fbd03f">

7. Import datafile "manager.sql" in to database
  
8. Modifiy the database connect information in application.yml
   <img width="1280" alt="image" src="https://github.com/dales2377/SDP2/assets/96338681/675cd1e5-34ea-440d-bff8-8d79491b1266">

9. running Springboot and Vue, the website link is http://localhost:8080/login




