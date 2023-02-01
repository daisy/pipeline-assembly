import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Pattern;

public class eval_java {

	public static void main(String[] args) {
		File thisExecutable = new File(args[0]); // path of eval-java(.exe) relative to current directory
		String javaCode = args[1];
		if ("true".equals(System.getenv("ECHO")))
			System.err.println(javaCode);
		try {
			String packageName = "temp";
			javaCode =
				"package " + packageName + ";\n"
				+ "import java.io.*;\n"
				+ "import static java.lang.System.err;\n"
				+ "import java.net.*;\n"
				+ "import java.nio.file.*;\n"
				+ "import java.util.*;\n"
				+ "import static lib.util.*;\n\n"
				+ "public class [CLASSNAME] {\n\n"
				+ "public static void main(String args[]) throws Throwable {\n\n"
				+ Pattern.compile(" *\\\\$", Pattern.MULTILINE).matcher(javaCode).replaceAll("") + "\n\n"
				+ "}\n}\n";
			String className = "temp_" + md5(javaCode) + "_" + getJavaVersion();
			javaCode = javaCode.replace("[CLASSNAME]", className);
			File javaDir = new File(thisExecutable.getParentFile(), "java");
			File classesDir = new File(thisExecutable.getParentFile(), "classes");
			File classFile = new File(new File(classesDir, packageName.replace('.', '/')), className + ".class");
			if (!classFile.exists()) {
				File javaFile = new File(new File(javaDir, packageName.replace('.', '/')), className + ".java");
				javaFile.getParentFile().mkdirs();
				OutputStream os = new FileOutputStream(javaFile);
				try {
					os.write(javaCode.getBytes("UTF-8"));
					os.flush();
				} finally {
					os.close();
				}
				String javac = System.getProperty("os.name").toLowerCase().startsWith("windows")
					? "javac.exe"
					: "javac";
				String JAVA_HOME = System.getenv("JAVA_HOME");
				if (JAVA_HOME != null) {
					File f = new File(new File(new File(JAVA_HOME), "bin"), javac);
					if (f.exists())
						javac = f.getAbsolutePath();
				}
				classesDir.mkdirs();
				int rv = new ProcessBuilder(
					javac,
					"-cp", classesDir.getAbsolutePath(),
					"-d", classesDir.getAbsolutePath(),
					javaFile.getAbsolutePath()
				).inheritIO().start().waitFor();
				System.out.flush();
				System.err.flush();
				if (rv != 0)
					System.exit(rv);
			}
			Class.forName(packageName + "." + className).getDeclaredMethod("main", String[].class).invoke(null, (Object)new String[0]);
		} catch (Throwable e) {
			e.printStackTrace();
			System.err.flush();
			System.exit(1);
		}
	}

	public static String md5(String data) throws NoSuchAlgorithmException, UnsupportedEncodingException {
		byte[] bytes = MessageDigest.getInstance("MD5").digest(data.getBytes("UTF-8"));
		StringBuilder s = new StringBuilder();
		for (int i = 0; i < bytes.length; i++)
			s.append(Integer
			         .toString((bytes[i] & 0xff) + 0x100, 16)
			         .substring(1));
		return s.toString();
	}

	public static int getJavaVersion() {
		String v = System.getProperty("java.version");
		if (v.startsWith("1."))
			v = v.substring(2, 3);
		else
			v = v.replaceAll("\\..*", "");
		return Integer.parseInt(v);
	}
}
