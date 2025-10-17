On Arch Linux, the process is the same. Here's how you can stop the process running on `localhost:8080`:

1. Find the PID of the process using port 8080:
   ```bash
   sudo lsof -i :8080
   ```

2. Identify the PID from the output.

3. Kill the process:
   ```bash
   kill -9 <PID>
   ```

Alternatively, you can use `ss` to find the PID:
```bash
sudo ss -lptn 'sport = :8080'
```

Then kill the process as before.
