function Cat = downloadPrepSpecGAIA(Args)
    % Download GAIA low-resolution spectra files and format into HDF5 catalog.
    % Input  : * ...,key,val,...
    %            'URL' - URL in which the spectra are stored.
    %                   Default is 'http://cdn.gea.esac.esa.int/Gaia/gdr3/Spectroscopy/xp_sampled_mean_spectrum/'
    %            'Wave' - Spectra wavelength. Default is (336:2:1020).'
    %            'Step' - Which step to execute:
    %                   1 - Download the catalogs.
    %                   2 - store as HDF5
    %                   3 - generate a CatsHTM
    % Author : Eran Ofek (Dec 2022)
    
    arguments
        
        Args.URL = 'http://cdn.gea.esac.esa.int/Gaia/gdr3/Spectroscopy/xp_sampled_mean_spectrum/';
        Args.Wave = (336:2:1020).';
        Args.Step = [1 2 3];
    end
    
    %%
    if any(Args.Step==1)
        % get all file names
        List = www.find_urls(Args.URL,'match','http.*?\.csv.gz');

        % download files
        www.pwget(List,'--no-check-certificate -U Mozilla',10);

        system('gzip -d *.csv.gz');
    end
    
    %
    if any(Args.Step==2)
        Nwave = numel(Args.Wave);
        Files = dir('XpSampledMean*.csv');
        Nfile = numel(Files);
        Cat   = nan(1e6, 6);
        K     = 0;
        for Ifile=1:1:Nfile
            [Ifile, Nfile]
            T = readtable(Files(Ifile).name, 'CommentStyle','#');
            Nspec = size(T,1);
            Spec  = nan(Nspec, 2.*Nwave);
            for Ispec=1:1:Nspec
                K       = K + 1;
                Flux    = eval(T.flux{Ispec});
                FluxErr = eval(T.flux_error{Ispec});
                Spec(Ispec,:) = [Flux, FluxErr];
                Cat(K,:)      = [T.ra(Ispec), T.dec(Ispec), T.source_id(Ispec), T.solution_id(Ispec), Ifile, Ispec];
            end
            % save hdf5 file of spectra
            'a'
            FileName = sprintf('GAIADR3_Spec_%06d.hdf5',Ifile);
            HDF5.save(Spec, FileName, '/Data');        
        end
    end
    
    %% save Cat into an CatsHTM
    if any(Args.Step==3)
        AC = AstroCatalog({Cat}, 'ColNames',{'RA','Dec','source_id','solution_id','Ifile','Ispec'});
        Nsrc = VO.prep.build_htm_catalog(AC, 'CatName','GAIADR3spec','HTM_Level',8);
    end
    
    
end