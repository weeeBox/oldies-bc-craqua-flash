package tasks;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;


public class RevisionTask extends Task 
{
	@Override
	public void execute() throws BuildException 
	{
		if(destinationFile == null)
		{
			throw new BuildException("destination file is not defined");
		}
		try
		{
			File svnFile = new File(sourceFile, ".svn/entries");
			System.out.println(svnFile.getAbsolutePath());
			BufferedReader reader = new BufferedReader(new FileReader(svnFile));
			for (int i = 0; i < 4; i++)
			{
				String line = reader.readLine();
				if (line.equals("dir"))
				{
					String revNum = reader.readLine();
					Document doc = null;
					if(destinationFile.exists())
					{
						doc = new SAXReader().read(destinationFile);
						doc.selectSingleNode("options/revision").setText(revNum);
					}
					else
					{
						doc = DocumentHelper.parseText("<options><revision>" + revNum + "</revision></options>");
					}
					XMLWriter writer = new XMLWriter(new FileWriter(destinationFile));
					writer.write(doc);
					writer.close();

					break;
				}
			}
			reader.close();
		}
		catch (FileNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new BuildException(e); 
		}
		catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new BuildException(e);
		}
		catch (DocumentException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new BuildException(e);
		}
	}
	
	private File destinationFile;
	public File getDestinationFile()
	{
		return destinationFile;
	}
	
	public void setDestinationFile(File file)
	{
		destinationFile = file;
	}
	
	private File sourceFile;
	public void setSource(File file)
	{
		sourceFile = file;
	}
}
