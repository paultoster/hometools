function flag = cell_compare(c1,c2)
%
% flag = cell_compare(c1,c2)
%
% compare cell if identical (only char and num )
%
% print out not identical
%
% flag = 1 if identical
% flag = 0 not identical
%
 flag = 0;
 [n1,m1] = size(c1);
 [n2,m2] = size(c2);

 for i = 1:n1
   for j = 1:m1
     element1 = c1{i,j};
     if( i > n2 )
       outtext = sprintf('c2{%i,:} does not exist',i);
     else
       if( j > m2 )
         outtext = sprintf('c2{:,%i} does not exist',i);
       else
         element2 = c2{i,j};
         outtext = cell_compare_proof_element(element1,element2,i,j);
       end
     end
     
     if( ~isempty(outtext) )
       fprintf('%s\n',outtext);
     end
   end
 end
 for i = n1+1:n2
   for j = m1+1:m2
     outtext = sprintf('c1{%i,%i} does not exist',i,j);
     
     if( ~isempty(outtext) )
       fprintf('%s\n',outtext);
     end
   end
 end
end
function outtext = cell_compare_proof_element(element1,element2,ic,jc)
  outtext = '';
  if( ischar(element1) )
    
    if(  ~ischar(element2) )
      outtext = sprintf('c1{%i,%i} is char c2{%i,%i} not',ic,jc,ic,jc);
    else
      if( ~strcmp(element1,element2) )
        outtext = sprintf('c1{%i,%i}=%s ungleich c2{%i,%i}=%s',ic,jc,element1,ic,jc,element2);
      end
    end
    
  elseif( isnumeric(element1) )
    
    if(  ~isnumeric(element2) )
      outtext = sprintf('c1{%i,%i} is num c2{%i,%i} not',ic,jc,ic,jc);
    else
     [n1,m1] = size(element1);
     [n2,m2] = size(element2);
     
     for i = 1:n1
       for j = 1:m1
       	val1 = element1(i,j);
        if( i > n2 )
          outtext = sprintf('c2{%i,%i}(%i,:) does not exist',ic,jc,i);
        else
          if( j > m2 )
            outtext = sprintf('c2{%i,%i}(:,%i) does not exist',ic,jc,j);
          else
            val2 = element2(i,j);
            if( abs(val1,val2) > eps )
              outtext = sprintf('c1{%i,%i}(%i,%i)=%f ungleich c2{%i,%i}(%i,%i)=%f',ic,jc,i,double(val1),ic,jc,i,j,double(val2));
            end
          end
        end
       end
     end
     for i = n1+1:n2
       for j = m1+1:m2
         outtext = sprintf('c1{%i,%i}(%i,%i) does not exist',ic,jc,i,j);
       end
     end

    end
  end
      
end
    
         
