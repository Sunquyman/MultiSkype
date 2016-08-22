package main;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Scanner;

import org.jasypt.util.text.BasicTextEncryptor;
import org.jasypt.util.text.StrongTextEncryptor;

public class MultiSkypeAuthEncryption {

	private ArrayList<AuthLogin> authList;
	private Scanner sc;

	public MultiSkypeAuthEncryption(){

		authList = new ArrayList<AuthLogin>();
		sc = new Scanner(System.in);

	}

	public void run(){

		System.out.println("MultiSkypeAuthEncryption program initialized.");
		boolean isFinished = false;
		//Loop to grab each authentication detail the user wants in his configuration
		while(!isFinished){
			System.out.println("Please enter a username. (Enter \"finished\" to exit)");

			String input = sc.nextLine();
			if(input.equals("finished")){
				if(authList.isEmpty()){
					System.out.println("You need to enter some auth details! Please enter a username.");
				}
				else {
					isFinished = true;
				}
			} else {

				String tempUsername = input;
				System.out.println("Please enter its password.");
				String tempPassword = sc.nextLine();
				System.out.println("Please enter a name to describe this login?");
				String tempName = sc.nextLine();
				authList.add(new AuthLogin(tempName, tempUsername, tempPassword));
				System.out.println("AuthLogin " + tempName + " added!");
			}

		}

		String authString = authListToString(authList);
		System.out.println("Auth details bundled!");

		//Now that we have the string of authentication details, we want to encrypt it
		//Using basic for now, because requires some installation for Strong...
		BasicTextEncryptor textEncryptor = new BasicTextEncryptor();
		System.out.println("Please enter a master key (password) for your logins (don't forget it!)");
		String masterKey = sc.nextLine();
		textEncryptor.setPassword(masterKey);
		String encryptedAuth = textEncryptor.encrypt(authString);

		//Writing the encrypted string to file...

		try {
			PrintWriter writer = new PrintWriter("authenc/encryptedauth.txt");
			writer.println(encryptedAuth);
			writer.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Error writing to file!");
		}
		System.out.println("Auth logins encrypted successfully! Program will now exit.");

	}


	public String authListToString(ArrayList<AuthLogin> inAuthList){

		String authString = "";
		for(int i = 0; i < inAuthList.size(); i++){
			authString = authString + inAuthList.get(i).toString() + ";";
		}
		return authString;
	}



	public class AuthLogin {

		private String name;
		private String username;
		private String password;

		public AuthLogin(String inName, String inUsername, String inPassword){

			name = inName;
			username = inUsername;
			password = inPassword;

		}

		public String toString(){
			return name + "," + username + "," + password;
		}

	}

}

