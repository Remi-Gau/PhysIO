function physio = tapas_physio_job2physio(job)
% Converts job from SPM batch editor to physio-structure
%
%   physio = tapas_physio_job2physio(job)
%
% IN
%
% OUT
%
% EXAMPLE
%   physio = tapas_physio_job2physio(job)
%
%   See also spm_physio_cfg_matlabbatch
%
% Author: Lars Kasper
% Created: 2015-01-05
% Copyright (C) 2015 TNU, Institute for Biomedical Engineering, University of Zurich and ETH Zurich.
%
% This file is part of the TAPAS PhysIO Toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.
%
% $Id: teditRETRO.m 464 2014-04-27 11:58:09Z kasperla $


physio                      = tapas_physio_new();

% Use existing properties that are cfg_choices in job to overwrite 
% properties of physio and set corresponding method

physio = tapas_physio_update_from_job(physio, job, ...
    {'preproc.cardiac.posthoc_cpulse_select', ...
    'preproc.cardiac.initial_cpulse_select', 'scan_timing.sync'}, ...
    {'preproc.cardiac.posthoc_cpulse_select', ...
    'preproc.cardiac.initial_cpulse_select', 'scan_timing.sync'}, ...
    true, ...
    'method');


% Use existing properties in job to overwrite properties of physio

physio = tapas_physio_update_from_job(physio, job, ...
    {'preproc.cardiac.modality', 'scan_timing.sqpar', ...
    'log_files', 'model', 'verbose', 'save_dir'}, ...
    {'preproc.cardiac.modality', 'scan_timing.sqpar', ...
    'log_files', 'model', 'verbose', 'save_dir'}, ...
    false);
