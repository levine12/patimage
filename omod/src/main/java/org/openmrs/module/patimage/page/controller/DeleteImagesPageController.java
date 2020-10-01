/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.patimage.page.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.util.OpenmrsUtil;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author levine
 */
public class DeleteImagesPageController {
	
	public void controller(HttpServletRequest request, PageModel model, HttpSession session) {
		
		String folderLocation = OpenmrsUtil.getApplicationDataDirectory() + "/patient_images";
		File folder = new File(folderLocation);
		File[] files = folder.listFiles();
		ArrayList<FileInfo> filesInfos = new ArrayList<FileInfo>();
		String fname, fileModifyDate;
		BasicFileAttributes att;
		Date date;
		for (File file : files) {
			try {
				fname = file.getName();
				Path filePath = file.toPath();
				att = Files.readAttributes(filePath, BasicFileAttributes.class);
				date = new Date(att.lastModifiedTime().toMillis());
				filesInfos.add(new FileInfo(fname, date.toString()));
			}
			catch (IOException ex) {
				Logger.getLogger(DeleteImagesPageController.class.getName()).log(Level.SEVERE, null, ex);
			}
		}
		model.addAttribute("filesInfos", filesInfos);
	}
	
	public String post(HttpSession session, HttpServletRequest request,
	        @RequestParam(value = "fileList", required = false) String fileList) {
		System.out.println("\n\nFILES TO DELETE\n" + fileList);
		String folderLocation = OpenmrsUtil.getApplicationDataDirectory() + "/patient_images";
		File folder = new File(folderLocation);
		File[] files = folder.listFiles();
		String[] fileStrings = fileList.split("%");
		List<String> fileNameList = Arrays.asList(fileList.split("%"));
		for (File file : files) {
			if (fileNameList.contains(file.getName())) {
				file.delete();
			}
		}
		return "redirect:" + "patimage/deleteImages.page";
	}
}

class FileInfo {
	
	private String fileName, fileModifyDate;
	
	public FileInfo(String fileName, String fileModifyDate) {
		this.fileName = fileName;
		this.fileModifyDate = fileModifyDate;
	}
	
	public String getFileName() {
		return fileName;
	}
	
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public String getFileModifyDate() {
		return fileModifyDate;
	}
	
	public void setFileModifyDate(String fileModifyDate) {
		this.fileModifyDate = fileModifyDate;
	}
}
