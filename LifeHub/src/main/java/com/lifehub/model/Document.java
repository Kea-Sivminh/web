package com.lifehub.model;
public class Document{
	private int id;
	private int userId;
	private String title;
	private String filePath;
	private String uploadDate;
	public Document() {
		
	}
	public Document(int id, int userId, String title, String filePath, String uploadDate) {
		this.id=id;
		this.userId=userId;
		this.title=title;
		this.filePath=filePath;
		this.uploadDate=uploadDate;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getUploadDate() {
		return uploadDate;
	}
	public void setUploadDate(String uploadDate) {
		this.uploadDate = uploadDate;
	}
}
