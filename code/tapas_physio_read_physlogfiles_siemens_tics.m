function [c, r, t, cpulse, acq_codes, verbose] = tapas_physio_read_physlogfiles_siemens_tics(...
    log_files, verbose)
% reads out physiological time series of Siemens logfiles with Tics
% The latest implementation of physiological logging in Siemens uses Tics,
% i.e. time stamps of 2.5 ms duration that are reset every day at midnight.
% These are used as a common time scale in all physiological logfiles -
% even though individual sampling times may vary - including cardiac,
% respiratory, pulse oximetry and acquisition time data itself
%
% [c, r, t, cpulse, acq_codes, verbose] = tapas_physio_read_physlogfiles_siemens_tics(...
%    log_files, verbose)
%
% IN    log_files
%       .log_cardiac        contains ECG or pulse oximeter time course
%                           for Siemens: *_PULS.log or _ECG[1-4].log.
%       .log_respiration    contains breathing belt amplitude time course
%                           for Siemens: *_RESP.log
%       .sampling_interval  1 entry: sampling interval (seconds)
%                           for both log files
%                           2 entries: 1st entry sampling interval (seconds)
%                           for cardiac logfile, 2nd entry for respiratory
%                           logfile
%       verbose
%       .level              debugging plots are created if level >=3
%       .fig_handles        appended by handle to output figure
%
% OUT
%   cpulse              time events of R-wave peak in cardiac time series (seconds)
%                       for GE: usually empty
%   r                   respiratory time series
%   t                   vector of time points (in seconds)
%                       NOTE: This assumes the default sampling rate of 400
%                       Hz
%   c                   cardiac time series (ECG or pulse oximetry)
%   acq_codes           slice/volume start events marked by number <> 0
%                       for time points in t
%                       10/20 = scan start/end;
%                       1 = ECG pulse; 2 = OXY max; 3 = Resp trigger;
%                       8 = scan volume trigger
%
% EXAMPLE
%   [ons_secs.cpulse, ons_secs.rpulse, ons_secs.t, ons_secs.c] =
%       tapas_physio_read_physlogfiles_siemens_tics(logfiles);
%
%   See also tapas_physio_main_create_regressors
%
% Author: Lars Kasper
% Created: 2014-09-08
% Copyright (C) 2014 Institute for Biomedical Engineering, ETH/Uni Zurich.
%
% This file is part of the PhysIO toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.
%
% $Id$

%% read out values
DEBUG = verbose.level >= 3;

hasRespirationFile = ~isempty(log_files.respiration);
hasCardiacFile = ~isempty(log_files.cardiac);

% Cardiac and respiratory sampling intervals are ignored, since Tics are
% assumed to be counted in files
dt = log_files.sampling_interval;

switch numel(dt)
    case 3
        dtTics = dt(3);
    otherwise
        dtTics = 2.5e-3;
end

dtCardiac = dtTics;
dtRespiration = dtTics;

acq_codes = [];

if hasRespirationFile
    fid = fopen(log_files.respiration);
    C = textscan(fid, '%d %d %d', 'HeaderLines', 1);
    
    % check whether textscan worked, otherwise try different format with 4
    % columns
    if ~isempty(C{2})
        r           = double(C{2});
        rSignals    = double(C{3});
        extTriggerSignals = [];
    else
        C           = textscan(fid, '%d %s %d %s %s', 'HeaderLines', 8);
        r           = double(C{3});
        rSignals    = ~cellfun(@isempty, C{4});
        extTriggerSignals = ~cellfun(@isempty, C{5});
    end
    
    
    rTics           = double(C{1});
    tRespiration    = rTics*dtRespiration ...
        - log_files.relative_start_acquisition;
    
    rpulse          = find(rSignals);
    
    nSamples        = numel(C{1});
    racq_codes       = zeros(nSamples,1);
    
    if ~isempty(rpulse)
        racq_codes(rpulse) = racq_codes(rpulse) + 3;
        rpulse = tRespiration(rpulse);
    end
    
    acqpulse          = find(extTriggerSignals);
    
    if ~isempty(acqpulse)
        racq_codes(acqpulse) = racq_codes(acqpulse) + 8;
    end
    
    
else
    rpulse          = [];
    r               = [];
    tRespiration    = [];
    racq_codes      = [];
end

if hasCardiacFile
    fid = fopen(log_files.cardiac);
    C = textscan(fid, '%d %d %d', 'HeaderLines', 1);
    
    % check whether textscan worked, otherwise try different format with 4
    % columns
    if ~isempty(C{2})
        c           = double(C{2});
        cSignals    = double(C{3});
    else
        C           = textscan(fid, '%d %s %d %s %s', 'HeaderLines', 8);
        c           = double(C{3});
        cSignals    = ~cellfun(@isempty, C{4});
        extTriggerSignals = ~cellfun(@isempty, C{5});
    end
    cTics           = double(C{1});
    tCardiac        = cTics*dtCardiac ...
        - log_files.relative_start_acquisition;
    
    nSamples        = numel(C{1});
    cacq_codes       = zeros(nSamples,1);
    
    cpulse          = find(cSignals);
    
    if ~isempty(cpulse)
        isOxy = any(strfind(upper(log_files.cardiac), 'PULS')); % different codes for PPU
        
        cacq_codes(cpulse) = cacq_codes(cpulse) + 1 + isOxy; %+1 for ECG, +2 for PULS
        cpulse = tCardiac(cpulse);
    end
    
    acqpulse          = find(extTriggerSignals);
    
    if ~isempty(acqpulse)
        cacq_codes(acqpulse) = cacq_codes(acqpulse) + 8;
    end
    
    
else
    c               = [];
    tCardiac        = [];
    cpulse          = [];
    cacq_codes      = [];
end



%% interpolate to greater precision, if 2 different sampling rates are given

if DEBUG
    fh = plot_raw_physlogs(tCardiac, c, tRespiration, r, ...
        hasCardiacFile, hasRespirationFile, cpulse, rpulse);
    verbose.fig_handles(end+1) = fh;
end


hasDifferentSampling = ~isequal(tCardiac, tRespiration);

if hasDifferentSampling && hasCardiacFile && hasRespirationFile
    %TODO: interpolate acq_codes
    
    nSamplesRespiration = size(r,1);
    nSamplesCardiac = size(c,1);
    dtCardiac = tCardiac(2)-tCardiac(1);
    dtRespiration = tRespiration(2) - tRespiration(1);
    
    isHigherSamplingCardiac = dtCardiac < dtRespiration;
    if isHigherSamplingCardiac
        t = tCardiac;
        rInterp = interp1(tRespiration, r, t);
        racq_codesInterp = interp1(tRespiration, racq_codes, t, 'nearest');
        acq_codes = cacq_codes + racq_codesInterp;
        
        if DEBUG
            fh = plot_interpolation(tRespiration, r, t, rInterp, ...
                {'respiratory', 'cardiac'});
            verbose.fig_handles(end+1) = fh;
        end
        r = rInterp;
        
    else
        t = tRespiration;
        cInterp = interp1(tCardiac, c, t);
        cacq_codesInterp = interp1(tCardiac, cacq_codes, t, 'nearest');
        acq_codes = racq_codes + cacq_codesInterp;
      
        if DEBUG
            fh = plot_interpolation(tCardiac, c, t, cInterp, ...
                {'cardiac', 'respiratory'});
            verbose.fig_handles(end+1) = fh;
        end
        c = cInterp;
        
    end
    
else
    
    % merge acq codes
    if hasCardiacFile
        if hasRespirationFile
            acq_codes = cacq_codes + racq_codes;
        else
            acq_codes = cacq_codes;
        end
    elseif hasRespirationFile
        acq_codes = racq_codes;
    end
    
    nSamples = max(size(c,1), size(r,1));
    t = -log_files.relative_start_acquisition + ((0:(nSamples-1))*...
        min(dtCardiac, dtRespiration))';
end

end

% Local function to plot raw read-in data;
function fh = plot_raw_physlogs(tCardiac, c, tRespiration, r, ...
    hasCardiacFile, hasRespirationFile, cpulse, rpulse)
fh = tapas_physio_get_default_fig_params();
stringTitle = 'Siemens Tics - Read-in cardiac and respiratory logfiles';
set(gcf, 'Name', stringTitle);
stringLegend = {};
tOffset = min([tRespiration; tCardiac]);
if hasCardiacFile
    plot(tCardiac-tOffset, c, 'r.-'); hold all;
    stringLegend{1, end+1} =  ...
        sprintf('Cardiac time course, start time %5.2e', tOffset);
    
    if ~isempty(cpulse)
        stem(cpulse-tOffset, max(abs(c))*ones(size(cpulse)));
        stringLegend{1, end+1} = 'Detected hearbeats';
    end
    
end

if hasRespirationFile
    plot(tRespiration-tOffset, r, 'g.-'); hold all;
    stringLegend{1, end+1} =  ...
        sprintf('Respiratory time course, start time %5.2e', tOffset);
    
    if ~isempty(rpulse)
        stem(rpulse-tOffset, max(abs(r))*ones(size(rpulse)));
        stringLegend{1, end+1} = 'Detected Breath starts';
    end
    
    
end
xlabel('t (seconds)');
legend(stringLegend);
title(stringTitle);
end

%% Local function to plot interpolation result
function fh = plot_interpolation(tOrig, yOrig, tInterp, yInterp, ...
    stringOrigInterp)
fh = tapas_physio_get_default_fig_params;
stringTitle = sprintf('Interpolation of %s signal', stringOrigInterp{1});
set(fh, 'Name', stringTitle);
plot(tOrig, yOrig, 'go--');  hold all;
plot(tInterp, yInterp,'r.');
legend({
    sprintf('after interpolation to %s timing', ...
    stringOrigInterp{1}), ...
    sprintf('original %s time series', stringOrigInterp{2}) });
title(stringTitle);
xlabel('time (seconds');
end

