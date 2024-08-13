package test.hashmap;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: 少不入川
 * @Date: 2023/3/11 21:19
 */
public class HashMapTest {

    public static void main(String[] args) {
        Map<Integer, String> map = new HashMap<>();
        for(int i = 0; i < 18; i++){
            map.put(i, String.valueOf(i));
        }
        System.out.println("hello world!");
    }

}
