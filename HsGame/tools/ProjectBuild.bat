:project_input  
@echo ��������Ŀ���ƣ����س�������HelloWorld  
@set /p project_name=  
@if "%project_name%"=="" echo.��Ŀ���Ʋ���Ϊ�գ���&goto :project_input  
  
  
:package_input  
@echo ��������������س�������com.sample.test  
@set /p package_name=  
@if "%package_name%"=="" echo.��������Ϊ�գ���&goto :package_input  
  
:lan_input  
@echo ��������������(cpp lua js)�����س�������lua  
@set /p lan_name=  
@if "%lan_name%"=="" echo.�������Ͳ���Ϊ�գ���&goto :lan_input  
  
:dir_input  
@echo �����빤���ļ��У�Ŀ¼λ�ã����س�������cocos  
@set /p dir_name=  
@if "%dir_name%"=="" echo.�����ļ��в���Ϊ�գ���&goto :dir_input  
  
  
@echo ��ʼ��������:%project_name%��������%package_name%���������ͣ�%lan_name%�������ļ��У�%dir_name%  
@cocos new %project_name% -p %package_name% -l %lan_name% -d %dir_name% 
@if not exist "%dir_name%" echo.����ʧ�ܣ���&goto :end  
  
  
@start ""  "%dir_name%"  
@echo �������!  
:end  
pause  