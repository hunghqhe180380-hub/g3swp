package scheduler;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

//server auto fire this function when start project
@WebListener
public class SchedulerListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        //create thread pool (has only 1 thread)
        scheduler = Executors.newScheduledThreadPool(1);

        //auto fire thread with period 1 seconds
        scheduler.scheduleAtFixedRate(
                new ClassCodeJob(),
                0,
                1,
                TimeUnit.SECONDS
        );

//        System.out.println("ClassCode Scheduler Started");

    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        //stop when shutdown or redeploy project
        scheduler.shutdown();
//        System.out.println("ClassCode Scheduler Stopped");

    }
}