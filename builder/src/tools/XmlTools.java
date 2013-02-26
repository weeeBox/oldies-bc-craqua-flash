package tools;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;
import org.xml.sax.InputSource;

public class XmlTools
{
	private static SAXReader reader = new SAXReader();
	private static String encoding = "UTF-8";
	
	public static Document readDoc(byte[] xmlBytes) throws DocumentException
	{
		InputSource source = new InputSource(new ByteArrayInputStream(xmlBytes));
		source.setEncoding(encoding);
		Document result = null;
		synchronized (reader)
		{
			result = reader.read(source);
		}
		return result;
	}
	
	public static Document readDoc(String xmlString) throws DocumentException
	{
		InputSource source = new InputSource(new StringReader(xmlString));
		source.setEncoding(encoding);
		Document result = null;
		synchronized (reader)
		{
			result = reader.read(source);
		}
		return result;
	}
	
	public static Document readDoc(InputStream inputStream) throws DocumentException
	{
		InputSource source = new InputSource(inputStream);
		source.setEncoding(encoding);
		Document result = null;
		synchronized (reader)
		{
			result = reader.read(source);
		}
		return result;
	}
	
	public static Document readDocFromFile(String fileName)  throws DocumentException
	{
		File paramsFile = new File(fileName);
    	try
		{
			FileInputStream fileInputStream = new FileInputStream(paramsFile);
			byte[] bytes = new byte[fileInputStream.available()];
			fileInputStream.read(bytes);
			return readDoc(bytes);
		} catch (FileNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
