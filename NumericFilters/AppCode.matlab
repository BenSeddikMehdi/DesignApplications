classdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TabGroup                       matlab.ui.container.TabGroup
        AppDesignTab                   matlab.ui.container.Tab
        PlotButton                     matlab.ui.control.Button
        CutoffFrequencyEditFieldLabel  matlab.ui.control.Label
        CutoffFrequency                matlab.ui.control.NumericEditField
        FilterOrderEditFieldLabel      matlab.ui.control.Label
        FilterOrder                    matlab.ui.control.NumericEditField
        WindowDropDownLabel            matlab.ui.control.Label
        WindowDropDown                 matlab.ui.control.DropDown
        PassbandRippleEditFieldLabel   matlab.ui.control.Label
        Ap                             matlab.ui.control.NumericEditField
        StopbandAttenLabel             matlab.ui.control.Label
        Ast                            matlab.ui.control.NumericEditField
        StopbandFreqLabel              matlab.ui.control.Label
        Fst                            matlab.ui.control.NumericEditField
        PassbandFreqLabel              matlab.ui.control.Label
        Fp                             matlab.ui.control.NumericEditField
    end

    methods (Access = private)

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            
            Hf = fdesign.lowpass('N,Fc',app.FilterOrder.Value,app.CutoffFrequency.Value);
             
            if app.WindowDropDown.Value == "Hamming"
               Hd1 = design(Hf,'window','window',@hamming,'systemobject',true);
               fvtool(Hd1,'Color','White');
               legend 'Hamming window design' 
               
            elseif app.WindowDropDown.Value == "Chebyshev"
               Hd2 = design(Hf,'window','window',{@chebwin,50},'systemobject',true);
               fvtool(Hd2,'Color','White');
               legend 'Dolph-ev window design Chebysh'
               
            elseif app.WindowDropDown.Value == "Hamming&Cheb"            
               Hd1 = design(Hf,'window','window',@hamming,'systemobject',true);
               Hd2 = design(Hf,'window','window',{@chebwin,50},'systemobject',true);
               fvtool(Hd1,Hd2,'Color','White');
               legend 'Hamming window design' 'Dolph-ev window design Chebysh'
            
            elseif app.WindowDropDown.Value == "Kaiser"         
                Hf = fdesign.lowpass('Fp,Fst,Ap,Ast'...
                    ,app.Fp.Value,app.Fst.Value,app.Ap.Value,app.Ast.Value);
                Hd3 = design(Hf,'kaiserwin','systemobject',true);
                fvtool(Hd3,'Color','White');
                legend 'Kaiser window design'
                
            elseif app.WindowDropDown.Value == "Equiripple"
                Hf = fdesign.lowpass('Fp,Fst,Ap,Ast'...
                    ,app.Fp.Value,app.Fst.Value,app.Ap.Value,app.Ast.Value);
                Hd4 = design(Hf,'equiripple','systemobject',true);
                fvtool(Hd4,'Color','White');
                legend 'Equiripple window design'
            end  
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create AppDesignTab
            app.AppDesignTab = uitab(app.TabGroup);
            app.AppDesignTab.Title = 'AppDesign';

            % Create PlotButton
            app.PlotButton = uibutton(app.AppDesignTab, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.BackgroundColor = [0.302 0.749 0.9294];
            app.PlotButton.FontName = 'Arial';
            app.PlotButton.FontSize = 15;
            app.PlotButton.FontWeight = 'bold';
            app.PlotButton.FontAngle = 'italic';
            app.PlotButton.Position = [268 62 103 39];
            app.PlotButton.Text = 'Plot';

            % Create CutoffFrequencyEditFieldLabel
            app.CutoffFrequencyEditFieldLabel = uilabel(app.AppDesignTab);
            app.CutoffFrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.CutoffFrequencyEditFieldLabel.Position = [34 401 97 22];
            app.CutoffFrequencyEditFieldLabel.Text = 'Cutoff Frequency';

            % Create CutoffFrequency
            app.CutoffFrequency = uieditfield(app.AppDesignTab, 'numeric');
            app.CutoffFrequency.Limits = [0 1];
            app.CutoffFrequency.Position = [146 401 100 22];
            app.CutoffFrequency.Value = 0.4;

            % Create FilterOrderEditFieldLabel
            app.FilterOrderEditFieldLabel = uilabel(app.AppDesignTab);
            app.FilterOrderEditFieldLabel.HorizontalAlignment = 'right';
            app.FilterOrderEditFieldLabel.Position = [411 401 66 22];
            app.FilterOrderEditFieldLabel.Text = 'Filter Order';

            % Create FilterOrder
            app.FilterOrder = uieditfield(app.AppDesignTab, 'numeric');
            app.FilterOrder.Limits = [0 Inf];
            app.FilterOrder.Position = [492 401 100 22];
            app.FilterOrder.Value = 100;

            % Create WindowDropDownLabel
            app.WindowDropDownLabel = uilabel(app.AppDesignTab);
            app.WindowDropDownLabel.HorizontalAlignment = 'right';
            app.WindowDropDownLabel.Position = [72 177 48 22];
            app.WindowDropDownLabel.Text = 'Window';

            % Create WindowDropDown
            app.WindowDropDown = uidropdown(app.AppDesignTab);
            app.WindowDropDown.Items = {'Hamming', 'Chebyshev', 'Hamming&Cheb', 'Kaiser', 'Equiripple', ''};
            app.WindowDropDown.Position = [135 177 111 22];
            app.WindowDropDown.Value = 'Hamming';

            % Create PassbandRippleEditFieldLabel
            app.PassbandRippleEditFieldLabel = uilabel(app.AppDesignTab);
            app.PassbandRippleEditFieldLabel.HorizontalAlignment = 'right';
            app.PassbandRippleEditFieldLabel.Position = [381 332 96 22];
            app.PassbandRippleEditFieldLabel.Text = 'Passband Ripple';

            % Create Ap
            app.Ap = uieditfield(app.AppDesignTab, 'numeric');
            app.Ap.Position = [492 332 100 22];
            app.Ap.Value = 0.06;

            % Create StopbandAttenLabel
            app.StopbandAttenLabel = uilabel(app.AppDesignTab);
            app.StopbandAttenLabel.HorizontalAlignment = 'right';
            app.StopbandAttenLabel.Position = [43 332 88 22];
            app.StopbandAttenLabel.Text = 'Stopband Atten';

            % Create Ast
            app.Ast = uieditfield(app.AppDesignTab, 'numeric');
            app.Ast.Position = [146 332 100 22];
            app.Ast.Value = 60;

            % Create StopbandFreqLabel
            app.StopbandFreqLabel = uilabel(app.AppDesignTab);
            app.StopbandFreqLabel.HorizontalAlignment = 'right';
            app.StopbandFreqLabel.Position = [46 259 85 22];
            app.StopbandFreqLabel.Text = 'Stopband Freq';

            % Create Fst
            app.Fst = uieditfield(app.AppDesignTab, 'numeric');
            app.Fst.Position = [146 259 100 22];
            app.Fst.Value = 0.42;

            % Create PassbandFreqLabel
            app.PassbandFreqLabel = uilabel(app.AppDesignTab);
            app.PassbandFreqLabel.HorizontalAlignment = 'right';
            app.PassbandFreqLabel.Position = [390 259 87 22];
            app.PassbandFreqLabel.Text = 'Passband Freq';

            % Create Fp
            app.Fp = uieditfield(app.AppDesignTab, 'numeric');
            app.Fp.Position = [492 259 100 22];
            app.Fp.Value = 0.38;
        end
    end

    methods (Access = public)

        % Construct app
        function app = app1

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
endclassdef app1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TabGroup                       matlab.ui.container.TabGroup
        AppDesignTab                   matlab.ui.container.Tab
        PlotButton                     matlab.ui.control.Button
        CutoffFrequencyEditFieldLabel  matlab.ui.control.Label
        CutoffFrequency                matlab.ui.control.NumericEditField
        FilterOrderEditFieldLabel      matlab.ui.control.Label
        FilterOrder                    matlab.ui.control.NumericEditField
        WindowDropDownLabel            matlab.ui.control.Label
        WindowDropDown                 matlab.ui.control.DropDown
        PassbandRippleEditFieldLabel   matlab.ui.control.Label
        Ap                             matlab.ui.control.NumericEditField
        StopbandAttenLabel             matlab.ui.control.Label
        Ast                            matlab.ui.control.NumericEditField
        StopbandFreqLabel              matlab.ui.control.Label
        Fst                            matlab.ui.control.NumericEditField
        PassbandFreqLabel              matlab.ui.control.Label
        Fp                             matlab.ui.control.NumericEditField
    end

    methods (Access = private)

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            
            Hf = fdesign.lowpass('N,Fc',app.FilterOrder.Value,app.CutoffFrequency.Value);
             
            if app.WindowDropDown.Value == "Hamming"
               Hd1 = design(Hf,'window','window',@hamming,'systemobject',true);
               fvtool(Hd1,'Color','White');
               legend 'Hamming window design' 
               
            elseif app.WindowDropDown.Value == "Chebyshev"
               Hd2 = design(Hf,'window','window',{@chebwin,50},'systemobject',true);
               fvtool(Hd2,'Color','White');
               legend 'Dolph-ev window design Chebysh'
               
            elseif app.WindowDropDown.Value == "Hamming&Cheb"            
               Hd1 = design(Hf,'window','window',@hamming,'systemobject',true);
               Hd2 = design(Hf,'window','window',{@chebwin,50},'systemobject',true);
               fvtool(Hd1,Hd2,'Color','White');
               legend 'Hamming window design' 'Dolph-ev window design Chebysh'
            
            elseif app.WindowDropDown.Value == "Kaiser"         
                Hf = fdesign.lowpass('Fp,Fst,Ap,Ast'...
                    ,app.Fp.Value,app.Fst.Value,app.Ap.Value,app.Ast.Value);
                Hd3 = design(Hf,'kaiserwin','systemobject',true);
                fvtool(Hd3,'Color','White');
                legend 'Kaiser window design'
                
            elseif app.WindowDropDown.Value == "Equiripple"
                Hf = fdesign.lowpass('Fp,Fst,Ap,Ast'...
                    ,app.Fp.Value,app.Fst.Value,app.Ap.Value,app.Ast.Value);
                Hd4 = design(Hf,'equiripple','systemobject',true);
                fvtool(Hd4,'Color','White');
                legend 'Equiripple window design'
            end  
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create AppDesignTab
            app.AppDesignTab = uitab(app.TabGroup);
            app.AppDesignTab.Title = 'AppDesign';

            % Create PlotButton
            app.PlotButton = uibutton(app.AppDesignTab, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.BackgroundColor = [0.302 0.749 0.9294];
            app.PlotButton.FontName = 'Arial';
            app.PlotButton.FontSize = 15;
            app.PlotButton.FontWeight = 'bold';
            app.PlotButton.FontAngle = 'italic';
            app.PlotButton.Position = [268 62 103 39];
            app.PlotButton.Text = 'Plot';

            % Create CutoffFrequencyEditFieldLabel
            app.CutoffFrequencyEditFieldLabel = uilabel(app.AppDesignTab);
            app.CutoffFrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.CutoffFrequencyEditFieldLabel.Position = [34 401 97 22];
            app.CutoffFrequencyEditFieldLabel.Text = 'Cutoff Frequency';

            % Create CutoffFrequency
            app.CutoffFrequency = uieditfield(app.AppDesignTab, 'numeric');
            app.CutoffFrequency.Limits = [0 1];
            app.CutoffFrequency.Position = [146 401 100 22];
            app.CutoffFrequency.Value = 0.4;

            % Create FilterOrderEditFieldLabel
            app.FilterOrderEditFieldLabel = uilabel(app.AppDesignTab);
            app.FilterOrderEditFieldLabel.HorizontalAlignment = 'right';
            app.FilterOrderEditFieldLabel.Position = [411 401 66 22];
            app.FilterOrderEditFieldLabel.Text = 'Filter Order';

            % Create FilterOrder
            app.FilterOrder = uieditfield(app.AppDesignTab, 'numeric');
            app.FilterOrder.Limits = [0 Inf];
            app.FilterOrder.Position = [492 401 100 22];
            app.FilterOrder.Value = 100;

            % Create WindowDropDownLabel
            app.WindowDropDownLabel = uilabel(app.AppDesignTab);
            app.WindowDropDownLabel.HorizontalAlignment = 'right';
            app.WindowDropDownLabel.Position = [72 177 48 22];
            app.WindowDropDownLabel.Text = 'Window';

            % Create WindowDropDown
            app.WindowDropDown = uidropdown(app.AppDesignTab);
            app.WindowDropDown.Items = {'Hamming', 'Chebyshev', 'Hamming&Cheb', 'Kaiser', 'Equiripple', ''};
            app.WindowDropDown.Position = [135 177 111 22];
            app.WindowDropDown.Value = 'Hamming';

            % Create PassbandRippleEditFieldLabel
            app.PassbandRippleEditFieldLabel = uilabel(app.AppDesignTab);
            app.PassbandRippleEditFieldLabel.HorizontalAlignment = 'right';
            app.PassbandRippleEditFieldLabel.Position = [381 332 96 22];
            app.PassbandRippleEditFieldLabel.Text = 'Passband Ripple';

            % Create Ap
            app.Ap = uieditfield(app.AppDesignTab, 'numeric');
            app.Ap.Position = [492 332 100 22];
            app.Ap.Value = 0.06;

            % Create StopbandAttenLabel
            app.StopbandAttenLabel = uilabel(app.AppDesignTab);
            app.StopbandAttenLabel.HorizontalAlignment = 'right';
            app.StopbandAttenLabel.Position = [43 332 88 22];
            app.StopbandAttenLabel.Text = 'Stopband Atten';

            % Create Ast
            app.Ast = uieditfield(app.AppDesignTab, 'numeric');
            app.Ast.Position = [146 332 100 22];
            app.Ast.Value = 60;

            % Create StopbandFreqLabel
            app.StopbandFreqLabel = uilabel(app.AppDesignTab);
            app.StopbandFreqLabel.HorizontalAlignment = 'right';
            app.StopbandFreqLabel.Position = [46 259 85 22];
            app.StopbandFreqLabel.Text = 'Stopband Freq';

            % Create Fst
            app.Fst = uieditfield(app.AppDesignTab, 'numeric');
            app.Fst.Position = [146 259 100 22];
            app.Fst.Value = 0.42;

            % Create PassbandFreqLabel
            app.PassbandFreqLabel = uilabel(app.AppDesignTab);
            app.PassbandFreqLabel.HorizontalAlignment = 'right';
            app.PassbandFreqLabel.Position = [390 259 87 22];
            app.PassbandFreqLabel.Text = 'Passband Freq';

            % Create Fp
            app.Fp = uieditfield(app.AppDesignTab, 'numeric');
            app.Fp.Position = [492 259 100 22];
            app.Fp.Value = 0.38;
        end
    end

    methods (Access = public)

        % Construct app
        function app = app1

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end