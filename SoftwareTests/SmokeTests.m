classdef SmokeTests < matlab.unittest.TestCase
    
    properties (ClassSetupParameter)
        Project = {char(currentProject().Name)};
    end

    properties (TestParameter)
        File;
    end

    methods (TestParameterDefinition,Static)

        function File = RetrieveFile(Project) %#ok<INUSD>
            % Retrieve the files to test
            RootFolder = currentProject().RootFolder;
            File = dir(fullfile(RootFolder,"Scripts","*.mlx"));
            File = {File.name}; 
        end

    end

    methods (TestClassSetup)

        function SetUpSmokeTest(testCase,Project) %#ok<INUSD>
            try
               currentProject;
               % Close the StartUp app if still open
               delete(findall(groot,'Name','StartUp App'))
            catch ME
                warning("Project is not loaded.")
            end
        end

    end
    
    methods(Test)

        function SmokeRun(testCase,File)

            % Check file system
            RootFolder = currentProject().RootFolder;
            cd(RootFolder)
            Filename = string(File);

            % Initialize test:
            %   - Pre-populate workspace
            %   - Overload functions
            InitFile = RetrieveInitFile(testCase,Filename);
            run(InitFile);

            % Run SmokeTest
            disp(">> Running " + Filename);
            try
                run(fullfile("Scripts",Filename));
            catch ME %#ok<*UNRCH>
                if ~any(strcmp(ME.identifier,KnownIssuesID))
                    disp("Error >>> Line "+ME.stack(1).line)
                    testCase.verifyTrue(false,ME.message);
                end
            end

            % Log every figure created during run
            Figures = findall(groot,'Type','figure');
            Figures = flipud(Figures);
            if ~isempty(Figures)
                for f = 1:size(Figures,1)
                    if ~isempty(Figures(f).Number)
                        FigDiag = matlab.unittest.diagnostics.FigureDiagnostic(Figures(f),'Formats','png');
                        log(testCase,1,FigDiag);
                    end
                end
            end

            % Close all figures and Simulink models
            close all force
            if any(matlab.addons.installedAddons().Name == "Simulink")
                bdclose all
            end

        end
            
    end


    methods (Access = private)

        function y = RetrieveInitFile(testCase,Filename)
            InitFile = "Init"+replace(Filename,".mlx",".m");
            InitFilePath = fullfile(currentProject().RootFolder,"SoftwareTests","InitFiles",InitFile);
            if ~isfolder(fullfile(currentProject().RootFolder,"SoftwareTests/InitFiles"))
                mkdir(fullfile(currentProject().RootFolder,"SoftwareTests/InitFiles"))
            end
            if ~isfile(InitFilePath)
                writelines("%  Initialization script for "+Filename,InitFilePath)
                writelines("% ---- Known Issues     -----",InitFilePath,'WriteMode','append');
                writelines("KnownIssuesID = "+char(34)+char(34)+";",InitFilePath,'WriteMode','append');
                writelines("% ---- Pre-run commands -----",InitFilePath,'WriteMode','append');
                writelines(" ",InitFilePath,'WriteMode','append');
            end
            y = InitFilePath;
        end

    end

end