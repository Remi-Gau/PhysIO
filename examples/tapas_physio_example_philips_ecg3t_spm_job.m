%-----------------------------------------------------------------------
% Job saved on 04-Sep-2018 17:05:51 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.tools.physio.save_dir = {''};
matlabbatch{1}.spm.tools.physio.log_files.vendor = 'Philips';
matlabbatch{1}.spm.tools.physio.log_files.cardiac = {'SCANPHYSLOG.log'};
matlabbatch{1}.spm.tools.physio.log_files.respiration = {'SCANPHYSLOG.log'};
matlabbatch{1}.spm.tools.physio.log_files.scan_timing = {'SCANPHYSLOG.log'};
matlabbatch{1}.spm.tools.physio.log_files.sampling_interval = [];
matlabbatch{1}.spm.tools.physio.log_files.relative_start_acquisition = 0;
matlabbatch{1}.spm.tools.physio.log_files.align_scan = 'last';
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nslices = 37;
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.NslicesPerBeat = [];
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.TR = 2.5;
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Ndummies = 3;
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nscans = 495;
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.onset_slice = 19;
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.time_slice_to_slice = [];
matlabbatch{1}.spm.tools.physio.scan_timing.sqpar.Nprep = [];
matlabbatch{1}.spm.tools.physio.scan_timing.sync.gradient_log.grad_direction = 'y';
matlabbatch{1}.spm.tools.physio.scan_timing.sync.gradient_log.zero = 0.4;
matlabbatch{1}.spm.tools.physio.scan_timing.sync.gradient_log.slice = 0.45;
matlabbatch{1}.spm.tools.physio.scan_timing.sync.gradient_log.vol = [];
matlabbatch{1}.spm.tools.physio.scan_timing.sync.gradient_log.vol_spacing = [];
matlabbatch{1}.spm.tools.physio.preproc.cardiac.modality = 'ECG';
matlabbatch{1}.spm.tools.physio.preproc.cardiac.initial_cpulse_select.load_from_logfile = struct([]);
matlabbatch{1}.spm.tools.physio.preproc.cardiac.posthoc_cpulse_select.off = struct([]);
matlabbatch{1}.spm.tools.physio.model.output_multiple_regressors = 'multiple_regressors.txt';
matlabbatch{1}.spm.tools.physio.model.output_physio = 'physio.mat';
matlabbatch{1}.spm.tools.physio.model.orthogonalise = 'none';
matlabbatch{1}.spm.tools.physio.model.censor_unreliable_recording_intervals = false;
matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.c = 3;
matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.r = 4;
matlabbatch{1}.spm.tools.physio.model.retroicor.yes.order.cr = 1;
matlabbatch{1}.spm.tools.physio.model.rvt.no = struct([]);
matlabbatch{1}.spm.tools.physio.model.hrv.no = struct([]);
matlabbatch{1}.spm.tools.physio.model.noise_rois.no = struct([]);
matlabbatch{1}.spm.tools.physio.model.movement.yes.file_realignment_parameters = {'rp_fMRI.txt'};
matlabbatch{1}.spm.tools.physio.model.movement.yes.order = 6;
matlabbatch{1}.spm.tools.physio.model.movement.yes.censoring_method = 'MAXVAL';
matlabbatch{1}.spm.tools.physio.model.movement.yes.censoring_threshold = [3 Inf];
matlabbatch{1}.spm.tools.physio.model.other.no = struct([]);
matlabbatch{1}.spm.tools.physio.verbose.level = 2;
matlabbatch{1}.spm.tools.physio.verbose.fig_output_file = 'PhysIO_output.fig';
matlabbatch{1}.spm.tools.physio.verbose.use_tabs = false;
