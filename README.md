# CarClub

CarClub is a web application built for car enthusiasts to showcase their vehicles and connect with others through shared interests. Users can create an account, build a personal "digital garage" by adding cars with photos, and explore other vehicles on the platform.

Beyond individual profiles, CarClub supports community interaction through clubs and events. Users can create or join clubs, organize and attend events, and even attach sponsors to events, making it feel closer to a real-world car scene.

This project was developed using JSP/Servlets with a MySQL backend.

<img width="1296" height="860" alt="image" src="https://github.com/user-attachments/assets/6843fe57-89f4-4fe3-8ff1-11fc7a107c83" />

---

## Features

- User registration, login, and logout
- Add, search, and delete cars
- Upload car and event photos
- Edit profile and delete account
- Create and search clubs, join/leave clubs
- Create, edit events 
- Register for events
- Manage event sponsors

---

## Directory Structure

```
CS157A-S1-Team-13/
├── carclubDB.sql                          # MySQL dump — import this to set up the database
└── CarClub/
    └── src/main/
        ├── java/carClubJava/
        │   └── MysqlCon.java              # All database logic (sql queries)
        └── webapp/
            ├── WEB-INF/classes/carClubJava/
            │   └── MysqlCon.class         
            ├── index.jsp                  
            ├── register.jsp
            ├── login.jsp / logout.jsp
            ├── AddCar.jsp
            ├── uploadCarPhoto.jsp
            ├── viewProfile.jsp
            ├── editProfile.jsp
            ├── deleteAccount.jsp
            ├── createClub.jsp             
            ├── clubs.jsp
            ├── createEvent.jsp            
            ├── events.jsp
            ├── uploadEventPhoto.jsp
            └── manageSponsors.jsp
```

---

## How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/vincentc168777/CS157A-S1-Team-13.git
   ```

2. **Set up the database**
   - Open MySQL Workbench (or your preferred MySQL client)
   - Import `carclubDB.sql` — this creates the `carclub` database and all tables with sample data
   ```bash
   mysql -u root -p < carclubDB.sql
   ```

3. **Configure the database connection**
   - Open `CarClub/src/main/java/carClubJava/MysqlCon.java`
   - Update the credentials if needed (default: `user = "root"`, `pass = "root"`)

4. **Compile the Java class**
   - Compile `MysqlCon.java` and place the output `.class` file in:
     `CarClub/src/main/webapp/WEB-INF/classes/carClubJava/`

5. **Deploy to Apache Tomcat**
   - Copy the `webapp/` folder contents into your Tomcat `webapps` directory
   - Start Tomcat and navigate to `http://localhost:8080`

---

## Contributors

- Samriddhi Matharu
- Sanjitha Kurra
- Vincent Cheng



