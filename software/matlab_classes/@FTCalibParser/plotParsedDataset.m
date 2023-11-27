function plotParsedDataset(obj, dirIdx, fileIdx, ftName)
%PLOTPARSEDDATASET Summary of this function goes here
%   Detailed explanation goes here

disp('------------------------------------------------------------------------------------')

% sanity check
noOfDirs = length(obj.dirStruct);
if(dirIdx > noOfDirs)
    error('[plotParsedDataset] The inserted directory index is larger than the parsed directories..')
else

    disp(['[plotParsedDataset] checking direcotry no.' num2str(dirIdx)])
    disp(['[plotParsedDataset] direcotry: ' num2str(obj.dirStruct{dirIdx}(1).folder)])
    noOfMatFilesInDir = length(obj.dirStruct{dirIdx});
    if(fileIdx > noOfMatFilesInDir)
        error(['[plotParsedDataset] The inserted file index is larger than the parsed files with the directory' dirIdx])
    else
        if(obj.dirStruct{dirIdx}(fileIdx).dataIsParsed)
            disp(['[plotParsedDataset] Checking data in file: ' num2str(obj.dirStruct{dirIdx}(fileIdx).name)])

            % check if the temperature data is added
            disp('[plotParsedDataset] The input dataset includes temperature.. It will be included in the plot..')
            legend_ft = 'FT sensor meas.';
            legend_exp = 'Expected meas.';
            legend_temp = 'FT Temperature';
            legend_location = 'best';
            sps = [1;3;5;2;4;6;7;8];
            sp_rows = 4;
            sp_cols = 2;
            titles = {'Force X','Force Y','Force Z','Torque X','Torque Y','Torque Z','Internal Temperature','Internal Temperature'};
            ylabels = {'Force [N]','Force [N]','Force [N]','Torque [N.m]','Torque [N.m]','Torque [N.m]','Temperature [°C]','Temperature [°C]'};
            xlabels = {'Time [s]','Time [s]','Time [s]','Time [s]','Time [s]','Time [s]','Time [s]','Time [s]'};

            fig = figure;
            fig.Position = [0 0 1500 1000];
            for p=1:length(sps)
                subplot(sp_rows,sp_cols,sps(p))
                % obj.dirStruct{i}(j).measures.FTs.(ft_names{k}).data
                if(p <= 6) % plot forces/torques
                    plot(obj.dirStruct{dirIdx}(fileIdx).measures.FTs.(ftName).time, obj.dirStruct{dirIdx}(fileIdx).measures.FTs.(ftName).data(:,p))
                else % plot temperature
                    plot(obj.dirStruct{dirIdx}(fileIdx).measures.FTs.(ftName).time, obj.dirStruct{dirIdx}(fileIdx).measures.temp.(ftName).data)
                end
                if(p <= 6) % plot expected forces/torques
                    hold on
                    plot(obj.dirStruct{dirIdx}(fileIdx).expectedValues.FTs.(ftName).time, obj.dirStruct{dirIdx}(fileIdx).expectedValues.FTs.(ftName).data(:,p))
                    legend(legend_ft, legend_exp, 'Location', legend_location)
                else
                    legend(legend_temp, 'Location', legend_location)
                end
                grid
                title(titles{p})
                ylabel(ylabels{p})
                xlabel(xlabels{p})
            end

            weights = strcat("l: ", obj.dirStruct{dirIdx}(fileIdx).leftWeight,", r: ", obj.dirStruct{dirIdx}(fileIdx).rightWeight);
            sgtitle({['Plotting in/out data for dataset: ' convertStringsToChars(obj.dirStruct{dirIdx}(fileIdx).name)] ['Type: ' obj.experimentType] ['Weights: ' convertStringsToChars(weights)] ['Plotting for FT: ' ftName]}, 'interpreter', 'none')
            disp('[plotParsedDataset] Done plotting')
        else
            warning('[plotParsedDataset] Data was not properly parsed into this object, aborting')
        end
    end
end


end
