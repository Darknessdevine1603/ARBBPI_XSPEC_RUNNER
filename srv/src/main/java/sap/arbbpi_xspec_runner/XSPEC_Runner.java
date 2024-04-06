package sap.arbbpi_xspec_runner;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.Instant;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.SwingConstants;
import javax.xml.XMLConstants;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class XSPEC_Runner  {

	private static final String[] xslSolutions = { "anBuyer", "fieldglass", "p2p", "s4", "s4HanaBuyer" , "CIM"};


	private static final String[] xslSolutions_Buyer = { "anBuyer", "fieldglass", "p2p", "s4",
			"s4HanaBuyer", "CIM" };

	public static void main(String[] args) {
		SpringApplication.run(XSPEC_Runner.class, args);

		// Get the OS Name, file seperator along with XSPEC Home folder
		String OSName = System.getProperty("os.name");
		System.out.println(OSName);
		String fileSperator = "/";

		String xspecHomeFolder = "";
		String xsltFolder = "";
		String xspecFolder = "";
		String commonFolder = "";
		String commandLineString = "";
		String xspeclogs = "";
		String xspeclogsCoverageStats = "";
		String xspeclogsCoverageSummary = "";
		//String homeDirectory = "";
		String xspecCommonFolder = "";
		String xspecSolution = "";
		String xspecReportsFolder;
		System.out.println("Task starting on: " + new Date());

		 File jarDir = new
		 File(ClassLoader.getSystemClassLoader().getResource(".").getPath());
		 System.out.println(jarDir.getAbsolutePath());

			commandLineString = System.getenv("HOME") + fileSperator + "XSLTCoverage.sh";

		xspecHomeFolder = "/home/user/projects/ARBBPI_XSPEC_RUNNER/XSPEC_HOME/";
		xspecReportsFolder = "/home/user/projects/ARBBPI_XSPEC_RUNNER/XSPEC_HOME/XSPEC/";

		for (int xsl_count = 0, n = xslSolutions.length; xsl_count < n; xsl_count++) {

			if (Arrays.asList(xslSolutions_Buyer).contains(xslSolutions[xsl_count])) {
				xsltFolder = "";
				xspecSolution = "";
				xspecSolution = "Buyer";
				xsltFolder = xspecHomeFolder + xspecSolution + "/" + "mapping" + "/"
						+ xslSolutions[xsl_count];
			}

			xspecFolder = xspecHomeFolder + "XSPEC" + "/" + "mapping" + fileSperator + xslSolutions[xsl_count];
			commonFolder = xspecHomeFolder + "common" + fileSperator;
			xspecCommonFolder = xspecHomeFolder + "XSPEC" + fileSperator + "common" + fileSperator + xspecSolution
					+ fileSperator;
			Instant startTime = Instant.now();

			System.out.println(
					"Running XSPEC Code Coverage for mappings of " + xslSolutions[xsl_count] + " at " + startTime + xsltFolder);

			// replace Binary File Parameter to local path
			String xlstFileContents[] = setFormatAnyAddOn_Local_from_Binary(xsltFolder, fileSperator, commonFolder,
					xspecCommonFolder, OSName, xspecSolution);

			File directoryPath = new File(xsltFolder);
			String xlstFiles[] = directoryPath.list();
			if (xlstFiles != null) {
				System.out.println("I found some XSLTs");
				// generate XSPEC files for each map
				xspeclogs = generateXSPEC_File_from_XSLT(xspecFolder, fileSperator, commandLineString, OSName);

				// generate XSPEC Coverage Statistics
				xspeclogsCoverageStats = generateXSPEC_CoverageStats(xspecFolder, fileSperator, commandLineString,
						OSName);

				// generate XSPEC Summary
				xspeclogsCoverageSummary = generateXSPEC_Summary(xspecFolder, xspecReportsFolder, fileSperator,
						xslSolutions[xsl_count], xlstFileContents);
			}

			// progressBar.setValue(Math.round((xsl_count + 1) * (100 /
			// xslSolutions.length)) + 10);
			Instant finishTime = Instant.now();
			System.out.println("Generated XSPEC Code Coverage Reports for mappings of " + xslSolutions[xsl_count]
					+ " at " + finishTime);
			if (Duration.between(startTime, finishTime).toMinutes() < 1) {
				System.out.println("Time taken to generate reports : "
						+ ( Duration.between(startTime, finishTime).toMinutes() * 60) + " seconds");
			} else {
				System.out.println("Time taken to generate reports : "
						+ Duration.between(startTime, finishTime).toMinutes() + " minute(s)");
			}

			System.out.println(" ######################### ");

		}

		writelogs(fileSperator, xspeclogs + xspeclogsCoverageStats + xspeclogsCoverageSummary);
		xspeclogs = "";
		xspeclogsCoverageStats = "";
		xspeclogsCoverageSummary = "";
		// Component frame = null;
		// progress();
		System.out.println("Task stopped on: " + new Date());
		// JOptionPane.showMessageDialog(frame, "XSPEC Report Done");

	}

	public static String[] setFormatAnyAddOn_Local_from_Binary(String xsltFolder, String fileSperator,
			String commonFolder, String xspecCommonFolder, String OSName, String xspecSolution) {
		if (xspecSolution == "Buyer") {

			String Str1_FormatAnyAddOn = "<xsl:include href=\"pd:HCIOWNERPID:FORMAT_AddOn_0000_cXML_0000:Binary\"/>";
			String Str1_FormatAnyAddOn_Replace = "<xsl:include href=\"../../../common/FORMAT_AddOn_0000_cXML_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str1_FormatAnyAddOn, Str1_FormatAnyAddOn_Replace,
					OSName);

			String Str2_FormatAnyAddOn = "<xsl:include href=\"pd:HCIOWNERPID:FORMAT_Apps_0000_AddOn_0000:Binary\"/>";
			String Str2_FormatAnyAddOn_Replace = "<xsl:include href=\"../../../common/FORMAT_Apps_0000_AddOn_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str2_FormatAnyAddOn, Str2_FormatAnyAddOn_Replace,
					OSName);

			String Str3_FormatAnyAddOn = "<xsl:include href=\"pd:HCIOWNERPID:FORMAT_cXML_0000_FieldGlass_0000:Binary\"/>";
			String Str3_FormatAnyAddOn_Replace = "<xsl:include href=\"../../../common/FORMAT_cXML_0000_FieldGlass_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str3_FormatAnyAddOn, Str3_FormatAnyAddOn_Replace,
					OSName);

			String Str4_FormatAnyAddOn = "<xsl:include href=\"pd:HCIOWNERPID:FORMAT_S4HANA_0000_cXML_0000:Binary\"/>";
			String Str4_FormatAnyAddOn_Replace = "<xsl:include href=\"../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str4_FormatAnyAddOn, Str4_FormatAnyAddOn_Replace,
					OSName);

			String Str5_FormatAnyAddOn = "<xsl:include href=\"pd:HCIOWNERPID:FORMAT_S4HANA_0000_S4HANA_0000:Binary\"/>";
			String Str5_FormatAnyAddOn_Replace = "<xsl:include href=\"../../../common/FORMAT_S4HANA_0000_S4HANA_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str5_FormatAnyAddOn, Str5_FormatAnyAddOn_Replace,
					OSName);

			String Str6_InvoiceCXMLEnv = "\\$exchange, 'cXMLEnvelope', \\$cXMLEnvelope";
			String Str6_InvoiceCXMLEnv_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str6_InvoiceCXMLEnv, Str6_InvoiceCXMLEnv_Replace,
					OSName);

			String Str7_InvoiceAttach = "\\$exchange, 'isANAttachment', 'YES'";
			String Str7_InvoiceAttach_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str7_InvoiceAttach, Str7_InvoiceAttach_Replace,
					OSName);

			String Str8_CCinvoice = "\\$exchange, 'anAttachmentName', 'CCInvoice.xml'";
			String Str8_CCinvoice_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str8_CCinvoice, Str8_CCinvoice_Replace, OSName);

			String Str9_MMinvoice = "\\$exchange, 'anAttachmentName', 'MMInvoice.xml'";
			String Str9_MMinvoice_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str9_MMinvoice, Str9_MMinvoice_Replace, OSName);

			String Str10_ERPSes = "\\$exchange, 'anAttachmentName', 'ERPServiceEntrySheetRequest.xml'";
			String Str10_ERPSes_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str10_ERPSes, Str10_ERPSes_Replace, OSName);

			String Str11_stripSpace = "<xsl:output";
			String Str11_stripSpace_Replace = "<xsl:strip-space elements=\"*\"/><xsl:output";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str11_stripSpace, Str11_stripSpace_Replace,
					OSName);

			String Str12_formatAnyAddon = "<xsl:include href=\"pd:HCIOWNERPID:FORMAT_S4HANA_0000_cXML_0000:Binary\"/>";
			String Str12_formatAnyAddon_Replace = "<xsl:include href=\"FORMAT_S4HANA_0000_cXML_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(commonFolder, fileSperator, Str12_formatAnyAddon,
					Str12_formatAnyAddon_Replace, OSName);

			String Str12A_formatAnyAddon_Replace = "<xsl:include href=\"../../../common/FORMAT_S4HANA_0000_cXML_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str12_formatAnyAddon,
					Str12A_formatAnyAddon_Replace, OSName);

			String Str13_formatAnyAddon = "\\$exchange, 'ancXMLAttachments', \\$ancXMLAttachments";
			String Str13_formatAnyAddon_Replace = "";
			replaceFormatAnyAddOn_with_Local(commonFolder, fileSperator, Str13_formatAnyAddon,
					Str13_formatAnyAddon_Replace, OSName);
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str13_formatAnyAddon,
					Str13_formatAnyAddon_Replace, OSName);

			String Str14_formatAnyAddoncommon = "../../../common/";
			String Str14_formatAnyAddoncommon_Replace = xspecCommonFolder;
			if (OSName.toUpperCase().contains("WINDOW") && Str14_formatAnyAddoncommon.contains("../../../common/")) {
				Str14_formatAnyAddoncommon_Replace = xspecCommonFolder.replace("\\", "/");
			}
			replaceFormatAnyAddOn_with_Local(commonFolder, fileSperator, Str14_formatAnyAddoncommon,
					Str14_formatAnyAddoncommon_Replace, OSName);

			String Str15_stripsetHeader = "<xsl:value-of select=\"hci:setHeader\\(\\)\"/>";
			String Str15_stripsetHeader_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str15_stripsetHeader,
					Str15_stripsetHeader_Replace, OSName);
			replaceFormatAnyAddOn_with_Local(commonFolder, fileSperator, Str15_stripsetHeader,
					Str15_stripsetHeader_Replace, OSName);

			String Str16_Attach = "\\$exchange, 'ancXMLAttachments', \\$ancXMLAttachments";
			String Str16_Attach_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str16_Attach, Str16_Attach_Replace, OSName);

			String Str17_formatAnyAddon = "\\$exchange, 'ansesrevoke', \\$v_revoke";
			String Str17_formatAnyAddon_Replace = "";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str17_formatAnyAddon,
					Str17_formatAnyAddon_Replace, OSName);

			String Str18_stripsetHeader = "<xsl:value-of select=\"hci:setHeader\\( \\)\"/>";
			String Str18A_stripsetHeader = "<xsl:value-of select=\"hci:setHeader\\(\\)\"/>";
			String Str18_stripsetHeader_Replace = "";
			replaceFormatAnyAddOn_with_Local(commonFolder, fileSperator, Str18_stripsetHeader,
					Str18_stripsetHeader_Replace, OSName);
			replaceFormatAnyAddOn_with_Local(commonFolder, fileSperator, Str18A_stripsetHeader,
					Str18_stripsetHeader_Replace, OSName);
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str18_stripsetHeader,
					Str18_stripsetHeader_Replace, OSName);
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str18A_stripsetHeader,
					Str18_stripsetHeader_Replace, OSName);

			String Str19_FormatAnyAddOn = "<xsl:include href=\"pd:HCIOWNERPID:FORMAT_cXML_0000_eTendering_0000:Binary\"/>";
			String Str19_FormatAnyAddOn_Replace = "<xsl:include href=\"../../../common/FORMAT_cXML_0000_eTendering_0000.xsl\"/>";
			replaceFormatAnyAddOn_with_Local(xsltFolder, fileSperator, Str19_FormatAnyAddOn,
					Str19_FormatAnyAddOn_Replace, OSName);

		}
		

		// Get all XSPEC files
		File directoryPath = new File(xsltFolder);
		String xlstFileContents[] = directoryPath.list();
		return xlstFileContents;

	}// End of setFormatAnyAddOn_Local_from_Binary

	public static void replaceFormatAnyAddOn_with_Local(String folderName, String fileSperator,
			String Str_FormatAnyAddOn, String Str_FormatAnyAddOn_Replace, String OSName) {
		// Get all XSPEC files

		File directoryPath = new File(folderName);
		String xlstFileContents[] = directoryPath.list();
		if (xlstFileContents != null) {
			for (int xslt_count = 0; xslt_count < xlstFileContents.length; xslt_count++) {
				if (xlstFileContents[xslt_count].endsWith(".xsl")) {
					// System.out.println(Str_FormatAnyAddOn);
					try {
						Path path = Paths.get(folderName + fileSperator + xlstFileContents[xslt_count]);
						Stream<String> lines = Files.lines(path);

						List<String> replacedFormatAddOn = lines
								.map(line -> line.replaceAll(Str_FormatAnyAddOn, Str_FormatAnyAddOn_Replace))
								.collect(Collectors.toList());

						Files.write(path, replacedFormatAddOn);
						lines.close();

					} catch (IOException e) {
						e.printStackTrace();
					}
				}

			}

		}

	}// End of replaceFormatAnyAddOn_with_Local

	public static String generateXSPEC_File_from_XSLT(String xspecFolder, String fileSperator, String commandLineString,
			String OSName) {
		File directoryPath = new File(xspecFolder);
		String xspecFileContents[] = directoryPath.list();
		String xspecfileName = "";
		String logFileString = "";
		String terminalorcommandwindow = "";

		Process commandWindow;
		if (OSName.toUpperCase().contains("LINUX")) {
			terminalorcommandwindow = "sh";

		} else {
			terminalorcommandwindow = "cmd.exe";

		}
		// System.out.println("generateXSPEC_File_from_XSLT");
		if (xspecFileContents != null) {
			// Get all XSPEC files
			for (int xspec_count = 0; xspec_count < xspecFileContents.length; xspec_count++) {

				// Check for empty folder
				if (xspecFileContents[xspec_count].endsWith(".xspec")) {
					System.out.println("XSPEC generated for the XSLT mapping of ... " + xspecFileContents[xspec_count]);
					String[] cmd = { terminalorcommandwindow, commandLineString,
							xspecFolder + fileSperator + xspecFileContents[xspec_count] };
					if (OSName.toUpperCase().contains("WINDOWS")) {
						String[] cmdWin = { terminalorcommandwindow, "/C", commandLineString,
								xspecFolder + fileSperator + xspecFileContents[xspec_count] };
						cmd = null;
						cmd = cmdWin;
					}
					xspecfileName = xspecFileContents[xspec_count].replace(".xspec", "");

					try {
						// Run the Coverage Report via ANT shell script
						commandWindow = Runtime.getRuntime().exec(cmd);
						commandWindow.waitFor();
						BufferedReader reader = new BufferedReader(
								new InputStreamReader(commandWindow.getInputStream()));
						while ((reader.readLine()) != null) {
							logFileString = logFileString + "XSPEC generated for " + xspecfileName + "\n";
						}
					} catch (IOException e2) {
						
						logFileString = logFileString + "Error generating XSPEC for " + xspecfileName + "\n";
						e2.printStackTrace();
					} catch (InterruptedException e1) {
						
						logFileString = logFileString + "Error generating XSPEC for " + xspecfileName + "\n";
						e1.printStackTrace();
					}

				} // End If - Check for empty folder
			} // End For Loop - Get all XSPEC files
		}
		return logFileString;
	}// End of generateXSPEC_File_from_XSLT

	public static String generateXSPEC_CoverageStats(String xspecFolder, String fileSperator, String commandLineString,
			String OSName) {
		String xspecResultHTMLReportPath = xspecFolder + fileSperator + "xspec";
		String userDir = System.getProperty("user.dir");
		Source xslt = new StreamSource(
				userDir + fileSperator + "files" + fileSperator + "CodeCoverage_HTMLResult_HTMLStats.xsl");
		// System.out.println("generateXSPEC_CoverageStats");

		// Get the XSLT file to transform the HTML Coverage Report

		Source xslt_input = null;
		Result xslt_output = null;
		File directoryPath = new File(xspecResultHTMLReportPath);
		String xspecHTMLFileContents[] = directoryPath.list();
		String tmp_CodeCoverageStats = null;

		String xspecCoverageResult = null;
		String xspecCoverageReport = null;
		String logFileString = "";

		if (xspecHTMLFileContents != null) {
			for (int xspec_html_count = 0; xspec_html_count < xspecHTMLFileContents.length; xspec_html_count++) {

				if (xspecHTMLFileContents[xspec_html_count].endsWith("-coverage.html")) {
					xslt_input = new StreamSource(
							xspecResultHTMLReportPath + fileSperator + xspecHTMLFileContents[xspec_html_count]);
					tmp_CodeCoverageStats = xspecHTMLFileContents[xspec_html_count].replace("-coverage.html", "");
					xslt_output = new StreamResult(new File(xspecResultHTMLReportPath + fileSperator
							+ tmp_CodeCoverageStats + "-CodeCoverageStats.html"));

					xspecCoverageResult = xspecResultHTMLReportPath + fileSperator + tmp_CodeCoverageStats
							+ "-result.html";
					xspecCoverageReport = xspecResultHTMLReportPath + fileSperator + tmp_CodeCoverageStats
							+ "-coverage.html";

					logFileString = XSLT_Transform(xslt, xslt_input, xslt_output, xspecCoverageResult,
							xspecCoverageReport, fileSperator, new Date());
				}
			} // end for loop
		} // end check for file contents
		return logFileString;
	}// End of generateXSPEC_CoverageStats

	public static String generateXSPEC_Summary(String xspecFolder, String xspecReportsFolder, String fileSperator,
			String moduleName, String[] xlstFileContents) {
		String userDir = System.getProperty("user.dir");
		Source summaryxslt = new StreamSource(
				userDir + fileSperator + "files" + fileSperator + "SummaryofCodeCoverage.xsl");
		File directoryPath = new File(xspecFolder + fileSperator + "xspec");
		String xspecAllFileContents[] = directoryPath.list();
		String absoluteCoverageReportPath = null;
		String summaryCoverageReport = "";
		String logFileString = "";
		String passedCount = "";
		String failedCount = "";

		String executedLines = "<td></td><td>ExecutedLines***</td><td style=\"font-family:arial;text-align:center;\">";
		String missedLines = "<td></td><td>MissedLines***</td><td style=\"font-family:arial;text-align:center;\">";
		String endLine = "</td>";

		int countExecutedLines = 0;
		int countMissedLines = 0;

		if (xspecAllFileContents != null) {
			int stringIndex = 0;
			for (int xspec_html_count = 0; xspec_html_count < xspecAllFileContents.length; xspec_html_count++) {

				if (xspecAllFileContents[xspec_html_count].endsWith("-CodeCoverageStats.html")) {
					absoluteCoverageReportPath = new java.io.File(xspecFolder + fileSperator + "xspec" + fileSperator
							+ xspecAllFileContents[xspec_html_count]).getAbsolutePath();

					String fileName = absoluteCoverageReportPath;
					File file = new File(fileName);

					// use UTF-8 encoding
					java.util.List<String> fileLinesList = null;
					try {
						fileLinesList = Files.readAllLines(file.toPath(), StandardCharsets.UTF_8);
					} catch (IOException e1) {
						
						logFileString = logFileString + "Error reading HTML results XSPEC for "
								+ xspecAllFileContents[xspec_html_count] + "\n";
						e1.printStackTrace();
					}

					for (String lineCount : fileLinesList) {
						if (lineCount.contains("Total Scenarios Passed:")) {
							passedCount = lineCount.replace("Total Scenarios Passed:", "");
						}
						if (lineCount.contains("Total Scenarios Failed:")) {
							failedCount = lineCount.replace("Total Scenarios Failed:", "");
						}
						if (lineCount.contains(executedLines)) {
							countExecutedLines = countExecutedLines + Integer.parseInt(
									lineCount.substring(lineCount.lastIndexOf(executedLines) + executedLines.length())
											.replace(endLine, ""));

						}
						if (lineCount.contains(missedLines)) {
							countMissedLines = countMissedLines + Integer.parseInt(
									lineCount.substring(lineCount.lastIndexOf(missedLines) + missedLines.length())
											.replace(endLine, ""));

						}

					}
					for (String line : fileLinesList) {
						/*
						 * if (line.contains("TotalLines***")) { TotalLines =
						 * line.substring(line.length() - 9).replace(">", "").replace("", "</td"); }
						 */

						if (line.contains("MAPPING_ANY_") && line.contains("<a href=") && line.contains("%")) {
							stringIndex = line.indexOf("%");
							summaryCoverageReport = summaryCoverageReport + "<SummaryCoverage><file>"
									+ absoluteCoverageReportPath + "</file><Coverage>"
									+ line.substring(stringIndex - 6, stringIndex).replace(">", "") + "</Coverage>"
									+ "<moduleName>" + moduleName + "</moduleName><PassedScenarios>" + passedCount
									+ "</PassedScenarios><FailedScenarios>" + failedCount
									+ "</FailedScenarios></SummaryCoverage>";

						}
					}
				}
			}

			String missedMappings = "";
			for (int xslt_count = 0; xslt_count < xlstFileContents.length; xslt_count++) {
				if (summaryCoverageReport.contains(xlstFileContents[xslt_count].replace(".xsl", "")) == false) {

					missedMappings = missedMappings + xlstFileContents[xslt_count] + "; \n";
				}
			}

			summaryCoverageReport = "<CoverageReportSummary>" + summaryCoverageReport + "<TotalMaps>"
					+ xlstFileContents.length + "</TotalMaps><MissedMappings>" + missedMappings
					+ "</MissedMappings><MissedLines>" + countMissedLines + "</MissedLines><TotalExecutedLines>"
					+ countExecutedLines + "</TotalExecutedLines></CoverageReportSummary>";

			String summaryFileName = xspecFolder + fileSperator + "CoverageReportSummary" + moduleName + ".xml";
			FileWriter fw = null;
			try {
				fw = new FileWriter(summaryFileName);
			} catch (IOException e1) {
				
				logFileString = logFileString + "Error opening file " + summaryFileName + "\n";
				e1.printStackTrace();
			}
			try {
				fw.write(summaryCoverageReport);
			} catch (IOException e1) {
				
				logFileString = logFileString + "Error writing to file " + summaryCoverageReport + "\n";
				e1.printStackTrace();
			}
			try {
				fw.close();
			} catch (IOException e1) {
				
				e1.printStackTrace();
			}

			Source summaryInputXML = new StreamSource(summaryFileName);
			Result summaryOutputXML = new StreamResult(new File("webapp" + fileSperator + moduleName + "_CoverageReportSummary-coverage.html"));

			logFileString = XSLT_Transform(summaryxslt, summaryInputXML, summaryOutputXML, "", "", fileSperator,
					new Date());

		}
		return logFileString;
	}// End of generateXSPEC_Summary

	public static String XSLT_Transform(Source xslt, Source xslt_input, Result xslt_output, String xspecCoverageResult,
			String xspecCoverageReport, String fileSperator, Date DateRun) {

		String logFileString = "";
		TransformerFactory factory = TransformerFactory.newInstance();
		factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "all");
		factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "all");
		Transformer transformer = null;
		System.out.println("I am inside Transform");
		try {
			transformer = factory.newTransformer(xslt);

		} catch (TransformerConfigurationException e1) {
			
			logFileString = logFileString + "Error in XSLT transformation of " + xslt_input + "\n";
			e1.printStackTrace();
		}
		try {
			// transformer.transform(xmlCoverageResult, new StreamResult(writer));
			// String xmlString = writer.getBuffer().toString();
			transformer.setParameter("ScenarioCoverageReport", xspecCoverageReport);
			transformer.setParameter("ScenarioCoverageResult", xspecCoverageResult);
			transformer.setParameter("fileSperator", fileSperator);
			transformer.setParameter("DateRun", DateRun);
			transformer.transform(xslt_input, xslt_output);

		} catch (TransformerException e1) {
			
			logFileString = logFileString + "Error in XSLT transformation of " + xslt_input + "\n";
			e1.printStackTrace();
		}
		return logFileString;
	} // end XSLT_Transform

	public static void progress() {
		JFrame progressFrame;

		JProgressBar progressBar;

		progressFrame = new JFrame("ProgressBar demo");

		// create a panel
		JPanel p = new JPanel();

		// create a progressbar
		progressBar = new JProgressBar(SwingConstants.HORIZONTAL);

		// set initial value
		progressBar.setValue(0);

		progressBar.setStringPainted(true);

		// add progressbar
		p.add(progressBar);

		// add panel
		progressFrame.add(p);

		// set the size of the frame
		progressFrame.setSize(200, 100);
		progressFrame.setVisible(true);
		fill(progressBar);

	}

	public static void fill(JProgressBar progressBar) {
		int i = 0;
		try {
			while (i <= 100) {
				// fill the menu bar
				progressBar.setValue(i + 10);

				// delay the thread
				Thread.sleep(1000);
				i += 20;
			}
		} catch (Exception e) {
		}
	}

	public static void writelogs(String fileSperator, String logString) {
		Logger logger = Logger.getLogger("XSPEC Logs");
		FileHandler fh;

		try {

			// This block configure the logger with handler and formatter
			String userDir = System.getProperty("user.dir");
			fh = new FileHandler(userDir + fileSperator + "files" + fileSperator + "XSPEC.log");
			logger.addHandler(fh);
			SimpleFormatter formatter = new SimpleFormatter();
			fh.setFormatter(formatter);

			// the following statement is used to log any messages
			logger.info(logString);

		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

}
}

