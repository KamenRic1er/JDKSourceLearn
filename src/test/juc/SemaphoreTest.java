package test.juc;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;

/**
 * @Author: 少不入川
 * @Date: 2023/3/1 11:01
 */
public class SemaphoreTest {

    // 创建Semaphore实例
    private static Semaphore semaphore = new Semaphore(0);

    public static void main(String[] args) throws InterruptedException {
        ExecutorService executorService = Executors.newFixedThreadPool(2);

        // 将线程A添加到线程池
        executorService.submit(new Runnable() {
            @Override
            public void run() {
                try{
                    System.out.println(Thread.currentThread() + "over");
                    // 该方法会将计数器加1
                    semaphore.release();
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        });

        // 将线程B添加到线程池
        executorService.submit(new Runnable() {
            @Override
            public void run() {
                try{
                    System.out.println(Thread.currentThread() + "over");
                    // 该方法会将计数器加1
                    semaphore.release();
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        });

        // 调用该方法主线程会阻塞在这里直到计数器为2
        semaphore.acquire(2);
        System.out.println("all child thread over!");

        // 关闭线程池
        executorService.shutdown();

    }

}
