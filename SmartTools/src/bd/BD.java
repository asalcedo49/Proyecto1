package bd;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;

public class BD {
	
	private final static String cnd_1 ="jdbc:postgresql://localhost:5432/SCT1",cnd_2= "app_user", cnd_3= "h7fzcws4";
	public static String ejecutar_sqls(String command, String [] vals, boolean text){
		try {
			String query = "select "+command+"(";
			if(vals !=null)
				for(int i =0; i< vals.length;i++){
					if(text)vals[i]="'"+vals[i]+"'";
					if(i!=0)
						query += ","+vals[i];
					else query += vals[i];
				}
			query += ");";
			return ejecutar_sqls(query);
			
		}
		catch(Exception e){
			e.printStackTrace();
			return "Error - "+e.getMessage();
		}
	}
	
	public static String ejecutar_sqls(String command, String  vals){
		try {
			String query = "select "+command+"(";
			if(vals !=null)
				query +="'"+vals+"'";;
			query += ");";
			return ejecutar_sqls(query);
			
		}
		catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	public static ArrayList<String> ejecutar_sql(String command, String [] vals){
		try {
			String query = "select "+command+"(";
			if(vals !=null)
				for(int i =0; i< vals.length;i++)
					if(i!=0)
						query += ","+vals[i];
					else query += vals[i];
			query += ");";
			return ejecutar_sql(query);
			
		}
		catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	public static ArrayList<String> ejecutar_sql(String command, String  vals){
		try {
			String query = "select "+command+"(";
			if(vals !=null)
				query += vals;
			query += ");";
			return ejecutar_sql(query);
			
		}
		catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	public static ArrayList<String[]> ejecutar_sql_as(String command, String  vals, boolean text){
		try {
			String query = "select * from "+command+"(";
			if(vals !=null)
				if(text) query += "'"+vals+"'";
				else query += vals;
			query += ");";
			return ejecutar_sql_as(query);
			
		}
		catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	public static ArrayList<String>  ejecutar_sql(String sql) throws SQLException, ClassNotFoundException{
		Connection connection = null;
		Class.forName("org.postgresql.Driver");
		connection = DriverManager.getConnection(cnd_1,cnd_2,cnd_3);
		   //"jdbc:postgresql://172.24.99.120:5432/sr","grupo1", "grupo12015");
		ArrayList<String> ret = new ArrayList<String>();
		PreparedStatement ps = connection.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			ret.add(rs.getString(1));
		}
		connection.close();
		return ret;
	}
	public static ArrayList<String[]>  ejecutar_sql_as(String sql) throws SQLException, ClassNotFoundException{
		Connection connection = null;
		Class.forName("org.postgresql.Driver");
		connection = DriverManager.getConnection(cnd_1,cnd_2,cnd_3);
		   //"jdbc:postgresql://172.24.99.120:5432/sr","grupo1", "grupo12015");
		ArrayList<String[]> ret = new ArrayList<String[]>();
		PreparedStatement ps = connection.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		ResultSetMetaData rsm = ps.getMetaData();
		String [] tmp;
		while(rs.next()){
			tmp = new String[rsm.getColumnCount()];
			for(int i=0; i<tmp.length;i++)
				tmp[i] =  rs.getObject(i+1)==null?"":rs.getObject(i+1).toString();
			ret.add(tmp);
		}
		connection.close();
		return ret;
	}
	private static String  ejecutar_sqls(String sql) throws SQLException, ClassNotFoundException{
		Connection connection = null;
		Class.forName("org.postgresql.Driver");
		connection = DriverManager.getConnection(cnd_1,cnd_2,cnd_3);
		   //"jdbc:postgresql://172.24.99.120:5432/sr","grupo1", "grupo12015");
		String ret = "";
		PreparedStatement ps = connection.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			ret=rs.getString(1);
		}
		connection.close();
		return ret;
	}
	public static String get_name(String orig){
		if(orig.lastIndexOf('.')<0)return "";
		String ext = orig.substring(orig.lastIndexOf('.'));
		return BD.ejecutar_sqls("fn_get_id", null)+ext;
		
	}
	public static void main(String[] args) {
	}

}
