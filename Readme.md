# **Custom Redis Cache**

## **Introduction**
**Custom Redis Cache** is a Docker-based caching system using **Redis** with **both RDB & AOF persistence** and **Redis Commander** as a web UI. The project includes:
- Redis with **persistent storage**.
- Redis Commander for **managing Redis via Web UI**.
- **Nginx reverse proxy support** for accessing Redis Commander via a hosted domain.
- A **shell script (`manage_redis.sh`)** to easily manage Redis containers.

---

## **🚀 Project Setup**

### **1️⃣ Clone the Repository**
```sh
git clone https://github.com/your-repo/custom-redis-cache.git
cd custom-redis-cache
```

### **2️⃣ Setup the `.env` File**
Create a `.env` file in the project root by copying `env-sample`:
```sh
cp env-sample .env
```
Modify `.env` with your **Redis credentials and configuration**:
```
REDIS_PASSWORD=your_secure_password
```

### **3️⃣ Build and Start the Containers**
Run the following command to start Redis and Redis Commander:
```sh
./manage_redis.sh qa up
```
This will:
- Replace `${REDIS_PASSWORD}` in `redis.conf`.
- Start Redis and Redis Commander containers.
- Enable persistence (AOF & RDB) for Redis.

---

## **🔄 Manage Redis Containers with `manage_redis.sh`**
The project includes a script `manage_redis.sh` to simplify managing Redis and Redis Commander.

### **Available Commands:**
```sh
./manage_redis.sh <environment> <command>
```

| Command | Description |
|---------|-------------|
| `build` | Build the Docker images (no cache) |
| `up` | Start the Redis & Redis Commander containers |
| `logs` | View logs in real time |
| `down` | Stop containers and remove volumes/images |

### **Examples:**
```sh
./manage_redis.sh qa build   # Build Docker images
./manage_redis.sh qa up      # Start Redis and Redis Commander
./manage_redis.sh qa logs    # View logs in real-time
./manage_redis.sh qa down    # Stop and remove containers
```

---

## **📡 Access Redis Commander**

### **1️⃣ Localhost Access**
If running on your local machine, access Redis Commander at:
```
http://localhost:8081
```

### **2️⃣ Hosted Domain Access** (via Nginx Reverse Proxy)
If configured with Nginx, access via:
```
http://commander.example.com
```
For **Redis access**:
```
http://cache.example.com
```

---

## **🛠️ Verifying Data Persistence**
To verify that **Redis data is persisting** correctly:

1️⃣ **Connect to Redis CLI (Inside Container)**
```sh
docker exec -it redis-cache redis-cli -h redis -p 6379 -a your_secure_password
```

2️⃣ **Insert Data into Redis**
```sh
SET user:1 "John Doe"
LPUSH messages "Hello" "World" "Redis Persistence Works!"
```

3️⃣ **Verify Data in Redis**
```sh
KEYS *
GET user:1
LRANGE messages 0 -1
```

4️⃣ **Check Data in Redis Commander**
- Open **Redis Commander** (`http://localhost:8081` or `http://commander.example.com`).
- You should see `user:1` and `messages` in the UI.

---

## **📜 Redis Configuration (`redis.conf`)**
The Redis configuration is stored in `redis.conf` and supports **both RDB & AOF persistence**.

---

## **🚀 Stopping Redis & Redis Commander**
To stop and remove all containers, volumes, and images:
```sh
./manage_redis.sh qa down
```

---

## **📝 Notes:**
- Ensure that your **domain names are properly configured** in your DNS settings.
- If using **Cloudflare or an external proxy**, make sure the correct **ports (8070 for Redis, 8081 for Redis Commander) are open**.
- Logs can be checked using:
  ```sh
  docker logs redis-cache
  docker logs redis_commander
  ```
- If Redis Commander shows **authentication errors**, ensure `REDIS_PASSWORD` is correctly set in `.env` and `docker-compose.yml`.

---

## **🎯 Summary**
✔ **Fully functional Redis caching system with persistence.**  
✔ **Web-based Redis management using Redis Commander.**  
✔ **Easily manage Redis services using `manage_redis.sh`.**  
✔ **Secure authentication with password-protected Redis.**  
✔ **Supports both localhost and hosted domains via Nginx.**  

🚀 **Now Redis is ready to cache and persist your data!** 🎯