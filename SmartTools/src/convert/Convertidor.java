package convert;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.Security;
import java.util.ArrayList;
import java.util.Properties;

import com.sun.mail.smtp.SMTPTransport;
import java.util.Date;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import bd.BD;

public class Convertidor {
	
	public static void main(String[] args) {
		Properties prop = new Properties();
		InputStream input = null;

		try {
			System.out.println("Working Directory = " + System.getProperty("user.dir"));
			input = new FileInputStream("./config.prop");
			prop.load(input);
			String root = prop.getProperty("root");
			String ffmpeg = prop.getProperty("ffmpeg");
			String out = prop.getProperty("out");
			String user = prop.getProperty("username");
			String pass = prop.getProperty("password");
			ArrayList<String[]> videos = BD.ejecutar_sql_as("fn_get_videos_pendeites", null, true);
			Process p;
			String[] tmp;
			String cmd;
			File encodingFile = null;
			for(int i=0; i<videos.size(); i++){
				tmp = videos.get(i);
				cmd = ffmpeg+"ffmpeg -i "+root+tmp[4]+" "+out+tmp[0]+".mp4 -v quiet";
				encodingFile = new File(out+tmp[0]+".mp4");
				if(!encodingFile.exists()){
					System.out.println(cmd);
					ProcessBuilder pb = new ProcessBuilder(ffmpeg+"ffmpeg","-i",root+tmp[4],out+tmp[0]+".mp4","-v","quiet");
					//encodingFile.createNewFile();
					/*pb.redirectErrorStream(true);
					pb.redirectInput(ProcessBuilder.Redirect.PIPE); //optional, default behavior
					pb.redirectOutput(encodingFile);*/
					p = pb.start();
					p.waitFor();
					//encodingFile.delete();
				}
				System.out.println(BD.ejecutar_sqls("fn_upd_estado_video", tmp[0]));
				Convertidor.Send(user, pass, tmp[3], "", "Video Convertido", "Video procesado");
				System.out.println(tmp[3]);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}
	public static void Send(final String username, final String password, String recipientEmail, String ccEmail, String title, String message) throws AddressException, MessagingException {
        Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";

        // Get a Properties object
        Properties props = System.getProperties();
        props.setProperty("mail.smtps.host", "smtp.gmail.com");
        props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
        props.setProperty("mail.smtp.socketFactory.fallback", "false");
        props.setProperty("mail.smtp.port", "465");
        props.setProperty("mail.smtp.socketFactory.port", "465");
        props.setProperty("mail.smtps.auth", "true");

        /*
        If set to false, the QUIT command is sent and the connection is immediately closed. If set 
        to true (the default), causes the transport to wait for the response to the QUIT command.

        ref :   http://java.sun.com/products/javamail/javadocs/com/sun/mail/smtp/package-summary.html
                http://forum.java.sun.com/thread.jspa?threadID=5205249
                smtpsend.java - demo program from javamail
        */
        props.put("mail.smtps.quitwait", "false");

        Session session = Session.getInstance(props, null);

        // -- Create a new message --
        final MimeMessage msg = new MimeMessage(session);

        // -- Set the FROM and TO fields --
        msg.setFrom(new InternetAddress(username + "@gmail.com"));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail, false));

        if (ccEmail.length() > 0) {
            msg.setRecipients(Message.RecipientType.CC, InternetAddress.parse(ccEmail, false));
        }

        msg.setSubject(title);
        msg.setText(message, "utf-8");
        msg.setSentDate(new Date());

        SMTPTransport t = (SMTPTransport)session.getTransport("smtps");

        t.connect("smtp.gmail.com", username, password);
        t.sendMessage(msg, msg.getAllRecipients());      
        t.close();
    }

}
