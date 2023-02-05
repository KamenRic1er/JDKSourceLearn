package test.juc;

/**
 * @Author: 少不入川
 * @Date: 2022/11/22 8:51
 */
public class ThreadLocalTest {
    public static void main(String[] args) {

        ThreadLocal<String> localVariable = new ThreadLocal<>();

        Thread thread1 = new Thread(new Runnable() {
            @Override
            public void run() {
                localVariable.set("thread1 running...");
                String temp = localVariable.get();
                System.out.println("thread1 : "+localVariable.get());
            }
        });
        Thread thread2 = new Thread(new Runnable() {
            @Override
            public void run() {
                localVariable.set("thread2 running...");
                System.out.println("thread2 : "+localVariable.get());
            }
        });

        thread1.start();
        thread2.start();

    }
}
