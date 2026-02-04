// Olivia Rueschhoff
// CS 470 Oracle Lab 4

import java.sql.*;
import java.io.*;
import java.util.*;


public class OracleLab4JDBC{
   
   static Connection conn;
   static Statement stmt;
   static BufferedReader keyboard;
   
   public static void main(String args[]) throws IOException{
      String username = "S25_omr100", password = "dg56mKFr";
      String ename;
      int original_empno = 0;
      int empno;
      
      keyboard = new BufferedReader(new InputStreamReader(System.in));
      
      try{
         DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
         System.out.println("Registered to the driver.");
         
         conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle2.wiu.edu:1521/orclpdb1", username, password);
         System.out.println("Logged into oracle as " + username);
         
         conn.setAutoCommit(false);
         stmt = conn.createStatement();

         boolean keepGoing = true;

         // Part 1: Insert & Update Options
         while(keepGoing){
             System.out.println("\n--- Menu ---");
             System.out.println("1. Insert new Doctor");
             System.out.println("2. Insert new Patient");
             System.out.println("3. Update Doctor's email");
             System.out.println("4. Update Patient's mobile");
             System.out.println("0. Exit");
             System.out.print("Enter your choice: ");
             String choiceStr = keyboard.readLine();
             int choice = Integer.parseInt(choiceStr);


             if(choice == 1){
               insertDoctor();
             } 
             else if(choice == 2){
               insertPatient();
             } 
             else if(choice == 3){
               updateDoctorEmail();
             } 
             else if(choice == 4){
               updatePatientMobile();
             } 
             else if(choice == 0){
               keepGoing = false;
               System.out.println("Exiting...");
             } 
             else{
               System.out.println("Incorrect input. Please enter a number between 0 and 4.");
             }
         }
          
         // Part 2: Query 
         // How many treatments has a hospital’s head doctor performed?
         String sql = "SELECT h.hos_id, h.hos_place, d.doc_name, COUNT(t.treat_id) AS treatment_count " +
         "FROM Hospitals h " +
         "JOIN Doctors d ON h.hos_doc_id = d.doc_id " +
         "JOIN Treatment t ON d.doc_id = t.doc_id " +
         "GROUP BY h.hos_id, h.hos_place, d.doc_name " +
         "ORDER BY treatment_count DESC";

         ResultSet rset = stmt.executeQuery(sql);
         System.out.printf("%-10s %-25s %-25s %-20s%n", "Hosp ID", "Location", "Doctor", "Treatment Count");
         System.out.println("-------------------------------------------------------------------------------");

      while (rset.next()) {
         int hosId = rset.getInt("hos_id");
         String place = rset.getString("hos_place");
         String docName = rset.getString("doc_name");
         int count = rset.getInt("treatment_count");

         System.out.printf("%-10d %-25s %-25s %-20d%n", hosId, place, docName, count);
      }
      rset.close();
      stmt.close();
      conn.close();
      } 
      catch(SQLException e){
         System.out.println("SQL Exception: " + e.getMessage());
      }
   }

   
   // Methods for menu
   public static void insertDoctor() throws IOException{
      try{
         System.out.print("Enter Doctor ID: ");
         int id = Integer.parseInt(keyboard.readLine());
         System.out.print("Enter Doctor Name: ");
         String name = keyboard.readLine();
         System.out.print("Enter Doctor Address: ");
         String address = keyboard.readLine();
         System.out.print("Enter Contact Number: ");
         String contact = keyboard.readLine();
         System.out.print("Enter Email: ");
         String email = keyboard.readLine();
   
         String sql = "INSERT INTO Doctors VALUES (" + id + ", '" + name + "', '" + address + "', '" + contact + "', '" + email + "')";
         stmt.executeUpdate(sql);
         conn.commit();
         System.out.println("Doctor inserted successfully.");
      } 
      catch(SQLException e){
         System.out.println("Error inserting doctor: " + e.getMessage());
      }
   }
      
   public static void insertPatient() throws IOException{
      try{
         System.out.print("Enter Patient ID: ");
         int id = Integer.parseInt(keyboard.readLine());
         System.out.print("Enter Patient Name: ");
         String name = keyboard.readLine();
         System.out.print("Enter Patient Mobile: ");
         String mobile = keyboard.readLine();            
         System.out.print("Enter Patient Address: ");
         String address = keyboard.readLine();
         System.out.print("Enter Contact Number: ");
         String contact = keyboard.readLine();
         System.out.print("Enter Email: ");
         String email = keyboard.readLine();
   
         String sql = "INSERT INTO Patients VALUES (" + id + ", '" + name + "', '" + mobile +"','" + address + "', '" + contact + "', '" + email + "')";
         stmt.executeUpdate(sql);
         conn.commit();
         System.out.println("Patient inserted successfully.");
      } 
      catch(SQLException e){
         System.out.println("Error inserting patient: " + e.getMessage());
      }
   }
   
   public static void updateDoctorEmail() throws IOException{
      try{
         System.out.print("Enter Doctor ID to update: ");
         int docId = Integer.parseInt(keyboard.readLine());
         System.out.print("Enter new Email: ");
         String newEmail = keyboard.readLine();
   
         String sql = "UPDATE Doctors SET doc_email = '" + newEmail + "' WHERE doc_id = " + docId;
         int rows = stmt.executeUpdate(sql);
   
         if(rows > 0){
            conn.commit();
            System.out.println("Doctor email updated successfully.");
         } 
         else{
            System.out.println("No doctor found with ID " + docId);
         }
      } 
      catch(SQLException e){
         System.out.println("Error updating doctor: " + e.getMessage());
      }
   }
   
   public static void updatePatientMobile() throws IOException{
      try{
         System.out.print("Enter Patient ID to update: ");
         int patId = Integer.parseInt(keyboard.readLine());
         System.out.print("Enter new Mobile Number: ");
         String newMobile = keyboard.readLine();
         String sql = "UPDATE Patients SET pat_mobile = '" + newMobile + "' WHERE pat_id = " + patId;
         int rows = stmt.executeUpdate(sql);
   
         if(rows > 0){
            conn.commit();
            System.out.println("Patient mobile updated successfully.");
         } 
         else{
            System.out.println("No patient found with ID " + patId);
         }
      } 
      catch(SQLException e){
         System.out.println("Error updating patient: " + e.getMessage());
      }
   }
}