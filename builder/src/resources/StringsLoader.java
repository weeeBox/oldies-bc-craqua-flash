package resources;

import java.io.File;
import java.io.IOException;

import org.dom4j.DocumentException;

public interface StringsLoader
{
    public void loadFile(File file) throws IOException, DocumentException;
    public int getRowsCount();
    public int getColsCount();
    public String getString(int row, int col);
}
