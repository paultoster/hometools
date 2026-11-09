function print_exception_to_screen(exception)


  if( isa(exception,'MException') )
    fprintf('%s\n',exception.message);
    
    for i=1:length(exception.stack)
      fprintf('=============================================\n')
      fprintf('file: %s \n',exception.stack(i).file);
      fprintf('name: %s \n',exception.stack(i).name);
      fprintf('line: %i \n',exception.stack(i).line);
    end  
  else
    fprintf('Error, exeption could not be printed');
  end
end