/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.patimage.fragment.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.openmrs.Patient;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.openmrs.util.OpenmrsUtil;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author levine
 */
public class PatientPicFragmentController {
	
	public void controller(HttpServletRequest request, FragmentModel model, HttpSession session,
	        @RequestParam(value = "patientId", required = false) Patient patient) {
		
		String folderLocation = OpenmrsUtil.getApplicationDataDirectory() + "/patient_images";
		String patientPictureFileName = null;
		String patientIdentifier = patient.getPatientIdentifier().getIdentifier();
		File folder = new File(folderLocation);
		File[] files = folder.listFiles();
		long oldCreationTime = 0, newCreationTime;
		
		//If this pathname does not denote a directory, then listFiles() returns null. 
		//Return most recent patient image file
		try {
			if (files != null) {
				for (File file : files) {
					//System.out.println("\nNEXT FILE: " + file.getName());
					if (file.isFile() && file.getName().contains("-" + patientIdentifier + ".")) {
						System.out.println("\nCHECKING: " + file.getName());
						Path filePath = file.toPath();
						BasicFileAttributes att = Files.readAttributes(filePath, BasicFileAttributes.class);
						newCreationTime = att.lastModifiedTime().toMillis();
						if (oldCreationTime < newCreationTime) {
							oldCreationTime = newCreationTime;
							patientPictureFileName = file.getName();
						}
					}
				}
			}
		}
		catch (IOException ex) {
			System.out.println("Exception in PatientPicFragmentController\n" + ex);
		}
		model.addAttribute("patientId", patient.getPatientIdentifier().getIdentifier());
		model.addAttribute("patientPictureFileName", patientPictureFileName);
		System.out.println("\n\n\n\n\n\nPATIENT ID: " + patientIdentifier + "\n\n" + "patientPictureFileName: "
		        + patientPictureFileName + "\n\n\n\n");
	}
}
