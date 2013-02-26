package resources;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.FileSet;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

public class StringsExportTask extends Task
{
	private static final String COLUMN_NAME = "Name";

	private File outputFile;
	
	private String language;
	
	public StringsExportTask()
	{
		files = new ArrayList<File>();
	}
	
	@Override
	public void execute() throws BuildException
	{
		checkParam(language, "Language not defined");
		checkParam(outputFile, "Output file not defined");

		try
		{
			for (FileSet set:filesets)
			{
				files.addAll(getIncludeFiles(set));
			}
			boolean changed = !outputFile.exists();
			if(!changed)
			{
				for (File inputFile : files)
				{
					if (inputFile.lastModified() > outputFile.lastModified())
					{
						changed = true;
						break;
					}
				}
			}
			if(changed)
			{
				List<ResString> resultStringSet = new ArrayList<ResString>();
				for (File inputFile : files)
				{
					System.out.println("file " + inputFile.getAbsolutePath());
					resultStringSet.addAll(readStrings(inputFile, language));
				}
				writeStrings(outputFile, resultStringSet);
			}
		} 
		catch (Exception e)
		{
			e.printStackTrace();
			throw new BuildException("Can't add text resource: " + e.getMessage(), e);
		}
	}

	private void writeStrings(File outputFile, List<ResString> set) throws IOException
	{
		Document doc = DocumentHelper.createDocument();
		Element root = doc.addElement("strings");
		
		for (ResString str : set)
		{
			Element element = root.addElement("string");
			element.addAttribute("id", str.getId());
			
			if (str.getData() == null)
			{
				System.err.println(" empty string id : " + str.getId());
				element.addText(str.getId());
			}
			else
			{
				element.addText(str.getData());
			}
		}
		
		writeDocument(outputFile, doc);
	}

	private void writeDocument(File outputFile, Document doc) throws IOException
	{
		XMLWriter writer = null;
		try
		{
			OutputFormat format = OutputFormat.createPrettyPrint();
			format.setTrimText(false);
			writer = new XMLWriter(new FileOutputStream(outputFile), format);
			writer.write(doc);
		} 
		finally
		{
			if (writer != null)
				writer.close();
		}
	}

	private void checkParam(Object param, String message)
	{
		if (param == null)
			throw new BuildException(message);
	}

	private List<ResString> readStrings(File sourceFile, String language) throws IOException, DocumentException
	{
		StringsLoader strLoader = new Excel2007Loader();
		strLoader.loadFile(sourceFile);
		
		int languageColumnIndex = -1;

		int row = 0;
		for (;; row++)
		{
			if (row >= strLoader.getRowsCount())
				throw new BuildException(
						"Row with language descriptions not found (cell in first column must contain '" + COLUMN_NAME + "'");

			String firstStr = strLoader.getString(row, 0);
			if (firstStr != null)
			{
				if (!firstStr.equalsIgnoreCase(COLUMN_NAME))
					throw new BuildException(
							"First non-empty cell in first column must contain text 'Name'");
				for (int col = 1; col < strLoader.getColsCount(); col++)
				{
					String str = strLoader.getString(row, col);
					if (str == null)
						continue;
					if (str.equalsIgnoreCase(language))
					{
						if (languageColumnIndex != -1)
							throw new BuildException("Duplicated '" + language + "' column");
						languageColumnIndex = col;
					} 
				}
				
				if (languageColumnIndex == -1)
					throw new BuildException("'" + language + "' column not found");
				
				break;
			}
		}

		// Р�РґРµРј РїРѕ СЃС‚СЂРѕРєР°Рј СЃС‚СЂР°РЅРёС†С‹ Рё Р·Р°РїРѕР»РЅСЏРµРј resultStringSet.
		List<ResString> resultStringSet = new ArrayList<ResString>();
		for (row++; row < strLoader.getRowsCount(); row++)
		{
			String name = strLoader.getString(row, 0);
			if (name == null)
				continue;

			String value = strLoader.getString(row, languageColumnIndex);
			resultStringSet.add(new ResString(name, value));
		}
		return resultStringSet;
	}

	static final class ResString
	{
		private String id;
		private String data;
		
		public ResString(String id, String data)
		{
			this.id = id;
			this.data = data;
		}

		public String getId()
		{
			return id;
		}

		public String getData()
		{
			return data;
		}
	}

	public void setInputFile(File inputFile)
	{
		files.add(inputFile);
	}

	public void setOutputFile(File outputFile)
	{
		this.outputFile = outputFile;
	}

	public void setLanguage(String language)
	{
		this.language = language;
	}
	
	private List<File> files;
	private List<FileSet> filesets = new ArrayList<FileSet>();
	
	public void add(FileSet set)
	{
		filesets.add(set);
	}
	
	private List<File> getIncludeFiles(FileSet set)
	{
		DirectoryScanner scanner = set.getDirectoryScanner();
		String[] filesNames = scanner.getIncludedFiles();
		File basedir = scanner.getBasedir();
		
		List<File> files = new ArrayList<File>(filesNames.length);
		for (int nameIndex = 0; nameIndex < filesNames.length; nameIndex++) 
		{
			String name = filesNames[nameIndex];
			files.add(new File(basedir, name));
		}
		
		return files;
	}
}
