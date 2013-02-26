package resources;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;

import tools.XmlTools;

class Excel2007Loader implements StringsLoader
{

	private ArrayList<ArrayList<Cell>> strings = new ArrayList<ArrayList<Cell>>();
	private int colsCount;
	private String errorString = new String(""); // Строка метка, нужна чтобы помечать строки с ошибкой.

	protected Excel2007Loader()
	{
		super();
	}

	public void loadFile(File fileName) throws IOException, DocumentException
	{
		ZipFile zipFile = new ZipFile(fileName);
		// reading unique strings
		ZipEntry entry = zipFile.getEntry("xl/sharedStrings.xml");
		Document xmlDoc = XmlTools.readDoc(zipFile.getInputStream(entry));
		
		Vector<String> uniqueStrings = new Vector<String>();

		for (Object childElementOb:xmlDoc.getRootElement().elements())
		{
			Element childElement = (Element) childElementOb;
			//String s =  (Element)(childElement.elements().get(0)).getText();
			Element stringElement = (Element)(childElement.elements().get(0));
			if(stringElement != null)
			{
				uniqueStrings.add(stringElement.getText());
			}
		}

		ZipEntry entryWorkbook = zipFile.getEntry("xl/workbook.xml");
		Document xmlDocWorkbook = XmlTools.readDoc(zipFile.getInputStream(entryWorkbook));
		
		Element sheets = xmlDocWorkbook.getRootElement().element("sheets");
		int elementsCount = sheets.elements().size();
		for (int sheet = 1; sheet <=  elementsCount; sheet++)
		{
			// filling resultStringSet
			entry = zipFile.getEntry("xl/worksheets/sheet" + sheet  + ".xml");
			xmlDoc = XmlTools.readDoc(zipFile.getInputStream(entry));
			Element root = xmlDoc.getRootElement().element("sheetData");

			//for (int rowIdx = 0; rowIdx < root.getChildCount(); rowIdx++)
			for(Object excelTableRowOb:root.elements())
			{
				ArrayList<Cell> row = new ArrayList<Cell>();
				Element excelTableRow = (Element) excelTableRowOb;
				if (!excelTableRow.hasContent())
					continue;
				
				String rowNumberStr = getElementSheetPos(excelTableRow);
				//for (int colIdx = 0; colIdx < excelTableRow.getChildCount(); ++colIdx)
				for(Object colOb:excelTableRow.elements())
				{
					Element col = (Element) colOb;
					int colNum = getColumnName(col, rowNumberStr).charAt(0) - 'A';
					if (colNum >= colsCount)
						colsCount = colNum + 1;
					Cell cell = new Cell(colNum, strByElement(uniqueStrings, col));
					row.add(cell);
				}
				strings.add(row);
			}
		}
		zipFile.close();
	}

	public int getRowsCount()
	{
		return strings.size();
	}

	public int getColsCount()
	{
		return colsCount;
	}

	public String getString(int rowNum, int colNum)
	{
		ArrayList<Cell> row = strings.get(rowNum);
		for (Cell c : row)
		{
			if (c.colNum == colNum)
			{
				if (c.string == errorString)
				{
					StringBuffer buffer = new StringBuffer();
					buffer.append("String has incorrect format (ROW: " + +(rowNum + 1) + ", COL: " + (colNum + 1) + ")");
					for (Cell cc : row)
					{
						if(cc.string == null)
							buffer.append("   | ");
						else if(cc.string == errorString)
							buffer.append("???| ");
						else
							buffer.append(cc.string + "| ");
					}
					throw new NullPointerException(buffer.toString());
				}
				else
					return c.string;
			}
		}

		return null;
	}

	private String getElementSheetPos(Element cell)
	{
		return cell.attributeValue("r");
	}

	private String getColumnName(Element col, String rowNumberStr)
	{
		String languageColumn;
		String s = getElementSheetPos(col);
		languageColumn = s.substring(0, s.length() - rowNumberStr.length());
		return languageColumn;
	}

	private String strByElement(Vector<String> uniqueStrings, Element col)
	{
		if (!col.hasContent())
			return null;
		String cellValue = col.elementText("v");
		Attribute columnType = col.attribute("t");
		return columnType != null && columnType.getValue().equals("s") ? uniqueStrings.get(Integer.parseInt(cellValue)) : cellValue;
	}

	private class Cell
	{
		public int colNum;
		public String string;

		public Cell(int colNum, String str)
		{
			this.colNum = colNum;
			this.string = str;
		}
	}

}
