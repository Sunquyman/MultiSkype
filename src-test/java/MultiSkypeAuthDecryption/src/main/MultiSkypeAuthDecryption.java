package main;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.Scanner;

import org.jasypt.util.text.BasicTextEncryptor;

public class MultiSkypeAuthDecryption {

	private String masterKey;

	public MultiSkypeAuthDecryption(String inKey){

		masterKey = inKey;

	}

	public void run(){

		BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
		textEncryptor.setPassword(masterKey);

		String encryptedInput = "";

		try {
			encryptedInput = new Scanner(new File("authenc/encryptedauth.txt")).useDelimiter("\\A").next();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		String decryptedOutput = textEncryptor.decrypt(encryptedInput);
		System.out.println(decryptedOutput);
	}

}
