classdef SmokeTests < matlab.unittest.TestCase

    properties
        RootFolder
        isSolnOnPath
    end
    
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

        function SetUpPath(testCase,Project)

            try
                % Close the StartUp app if still open
                delete(findall(groot,'Name','StartUp App'))
                % Check that Solutions are on path
                testCase.RootFolder = currentProject().RootFolder;
                cd(testCase.RootFolder)
                testCase.isSolnOnPath = exist("Solutions","dir");
                if testCase.isSolnOnPath == 0
                    addpath(fullfile(testCase.RootFolder,"InstructorResources","Solutions"))
                end
            catch ME
                warning("Load project prior to run tests")
                rethrow(ME)
            end

            testCase.log("Running in " + version)

        end

    end
    
    methods(Test)

        function SmokeRun(testCase,File)

            % Check file system
            cd(testCase.RootFolder)
            Filename = string(File);

            % Pre-test:
            PreFiles = CheckPreFile(testCase,Filename);
            run(PreFiles);

            % Run SmokeTest
            disp(">> Running " + Filename);
            try
                run(fullfile("Scripts",Filename));
            catch ME
                if ~any(strcmp(ME.identifier,KnownIssuesID))
                    rethrow(ME)
                end
            end

            % Post-test:
            PostFiles = CheckPostFile(testCase,Filename);
            run(PostFiles)

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
            
        % Test that all the Script files have solution versions
        function ExistSolns(testCase,File)
            Filename = replace(string(File),".mlx","Soln.mlx");
            SolnFilePath = fullfile(testCase.RootFolder,"InstructorResources","Solutions",Filename);
            if ~isfile(SolnFilePath)
                error(SolnFileName + " doesn't exist")
            end
        end

        function SmokeRunSoln(testCase,File)

            % Check file system
            cd(testCase.RootFolder)
            OriginalFile = string(File);
            SolutionFile = replace(File,".mlx","Soln.mlx");

            % Pre-test:
            [PreFiles,OnSolution] = CheckPreFile(testCase,OriginalFile);
            if OnSolution
                run(PreFiles);
            end

            % Run SmokeTest
            disp(">> Running " + SolutionFile);
            try
                run(fullfile(testCase.RootFolder,"InstructorResources","Solutions",SolutionFile));
            catch ME
                if ~any(strcmp(ME.identifier,KnownIssuesID))
                    rethrow(ME)
                end
            end

            % Post-test:
            [PostFiles,OnSolution] = CheckPostFile(testCase,OriginalFile);
            if OnSolution
                run(PostFiles)
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

        function [Path,OnSolution] = CheckPreFile(testCase,Filename)

            % Create path to pre-run file
            PreFile = "Pre"+replace(Filename,".mlx",".m");
            PreFilePath = fullfile(testCase.RootFolder,"SoftwareTests","PreFiles",PreFile);
            if ~isfolder(fullfile(testCase.RootFolder,"SoftwareTests/PreFiles"))
                mkdir(fullfile(currentProject().RootFolder,"SoftwareTests/PreFiles"))
            end

            % Create standard pre-run file, if file does not exist
            if ~isfile(PreFilePath)
                writelines("%  Pre-run script for "+Filename,PreFilePath)
                writelines("% ---- Run on solutions -----",PreFilePath,'WriteMode','append');
                writelines("OnSolution = false;")
                writelines("% ---- Known Issues     -----",PreFilePath,'WriteMode','append');
                writelines("KnownIssuesID = "+char(34)+char(34)+";",PreFilePath,'WriteMode','append');
                writelines("% ---- Pre-run commands -----",PreFilePath,'WriteMode','append');
                writelines(" ",PreFilePath,'WriteMode','append');
            end

            % Return path to file and flag to run on solutions
            Path = PreFilePath;
            run(PreFilePath);
            if ~exist("OnSolution","var")
                OnSolution = false;
            end

        end

        function [Path,OnSolution] = CheckPostFile(testCase,Filename)

            % Create path to post-run file
            PostFile = "Post"+replace(Filename,".mlx",".m");
            PostFilePath = fullfile(testCase.RootFolder,"SoftwareTests","PostFiles",PostFile);
            if ~isfolder(fullfile(testCase.RootFolder,"SoftwareTests/PostFiles"))
                mkdir(fullfile(testCase.RootFolder,"SoftwareTests/PostFiles"))
            end

            % Create standard post-run file, if file does not exist
            if ~isfile(PostFilePath)
                writelines("%  Post-run script for "+Filename,PostFilePath)
                writelines("% ---- Run on solutions -----",PreFilePath,'WriteMode','append');
                writelines("OnSolution = false;")
                writelines("% ---- Post-run commands -----",PostFilePath,'WriteMode','append');
                writelines(" ",PostFilePath,'WriteMode','append');
            end
            
            % Return path to file and flag to run on solutions
            Path = PostFilePath;
            run(PostFilePath);
            if ~exist("OnSolution","var")
                OnSolution = false;
            end

        end

    end

end