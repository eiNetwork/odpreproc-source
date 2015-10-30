package org.extract.dbtools;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.HashSet;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
/**
 * Populate indexedMetaDataTable, 
 * 
 *
 */

public class IndexedMetaDataTable {
	private static Logger logger = Logger.getLogger(IndexedMetaDataTable.class);
	private Connection conn;
	
	
	public IndexedMetaDataTable(Connection conn){
		this.conn = conn;
	}
	public void setConnection(Connection conn){
		this.conn = conn;
	}
	/**
	 * populate indexedMetaData table
	 */
	public void setIndexMetaDataTable(){
		DatabaseQueries iterationQueries = new DatabaseQueries(conn);
		DatabaseQueries updateInsertQueries = new DatabaseQueries(conn);
		HashSet<String> columns = new HashSet<String>();
		columns.add("id");
		columns.add("sourceMetaData");
		//columns.add("totalCopies");
		//columns.add("availabeCopies");
		//columns.add("numberOfHolds");
		ResultSet resultSet = iterationQueries.selectAllRows("externalData", columns);
		try {
			HashMap<String, Object> condition = new HashMap<String, Object>();
			while(resultSet.next()){
				JSONObject metaDataJSON = stringToJSONObject(resultSet.getString("sourceMetaData"));
				if(metaDataJSON == null){
					logger.debug("Skipping an entry");
				}else{
					try {
						HashMap<String, Object> contentMap = new HashMap<String, Object>();
						if( metaDataJSON.has("title") ) {
							String titleStr = metaDataJSON.getString("title").replace("\"", "\\\"");
							contentMap.put("title", titleStr );
							contentMap.put("title_sub", titleStr);
							contentMap.put("title_short", titleStr);
							contentMap.put("title_full", titleStr);
							contentMap.put("title_auth", titleStr);
						}
						if( metaDataJSON.has("sortTitle") ) {
							contentMap.put("title_sort",metaDataJSON.getString("sortTitle").replace("\"", "\\\"") );
						}
						if( metaDataJSON.has("creators") ) {
							JSONObject creator0 = metaDataJSON.getJSONArray("creators").optJSONObject(0);
							if( creator0 != null && creator0.has("fileAs") )
							{
								contentMap.put("author", creator0.getString("fileAs").replace("\"", "\\\"") );
							}
						}
						if( metaDataJSON.has("languages") ) {
							contentMap.put("language", metaDataJSON.getJSONArray("languages").toString().replace("\"", "\\\""));
						}
						if( metaDataJSON.has("publisher") ) {
							contentMap.put("publisher", metaDataJSON.getString("publisher").replace("\"", "\\\""));						
						}
						if( metaDataJSON.has("publishDate") ) {
							contentMap.put("publishDate", metaDataJSON.getString("publishDate").replace("\"", "\\\""));
						}
						if( metaDataJSON.optJSONObject("images") != null ) {
							JSONObject images = metaDataJSON.getJSONObject("images");
							if( images != null && images.optJSONObject("cover") != null )
							{
								contentMap.put("thumbnail", images.getJSONObject("cover").getString("href").replace("\"", "\\\""));
							}
							else if( images != null && images.optJSONObject("thumbnail") != null )
							{
								contentMap.put("thumbnail", images.getJSONObject("thumbnail").getString("href").replace("\"", "\\\""));
							}
						}
												
						condition.clear();
						int resultID = resultSet.getInt("id");
						condition.put("id", resultID);
						if( updateInsertQueries.exists("indexedMetaData",condition, "=") )
						{
							//logger.debug(resultID + " Updating indexedMetaData");
							updateInsertQueries.updateTable("indexedMetaData", contentMap, condition, "=");
						}
						else
						{
							logger.debug(resultID + " Inserting into indexedMetaData table ");
							contentMap.put("id", resultID);
							updateInsertQueries.insertIntoTable("indexedMetaData", contentMap);
						}
					} catch (JSONException e) {
						logger.error("JSON error " + e);
					}
				}
				
			}
		} catch (SQLException e) {
			logger.error(e);
		} finally {
			try { if( resultSet != null ) resultSet.close(); } catch (Exception e) {};
		}
		
	}
	
	/**
	 * Convert JSONString to JSONObject, handle some of the string object not handled by JSONObject. 
	 * This currently uses modified JSONObject class which ignore escape characters, so if the JSONObject
	 * class is changed the escape sequence has to be uncommented
	 * @param metaData
	 * @return
	 */
	private JSONObject stringToJSONObject( String metaData){
		
		JSONObject metaDataJSON = null;
		
		metaData = metaData.replace("\"", "\"");		// don't know why it does not work with out this
		//metaData = metaData.replace("\t", "\\t"); 
		//metaData = metaData.replace("\n", "\\n"); 
		
		metaData = metaData.replace(":,", ":null,");	
		metaData = metaData.replace(":}", ":null}");
		
		try {
			metaDataJSON = new JSONObject(metaData);
		} catch (JSONException e) {
			logger.debug("metaData : " + metaData);
			logger.error("Cound not convert string to JSON " +  e );
			//System.exit(0);
			return null;
		}
		return metaDataJSON;
	}

}
