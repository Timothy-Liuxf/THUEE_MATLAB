function [y, beta_param] = env2(x)
    alpha_param = 0.1;
    gamma_param = 0.3;
    beta_param = 1.2;
    delta_param = 1 + (gamma_param-alpha_param)./(alpha_param-beta_param);
    A = -1./(alpha_param.^2);
    B = (delta_param-1)./(gamma_param-alpha_param).^2;
    C = (gamma_param-alpha_param)./(gamma_param-beta_param) .* B;
    
    y = ...
        (x >= 0 & x < alpha_param) .* (A .* (x-alpha_param).^2 + 1) + ...
        (x >= alpha_param & x < gamma_param) .* (B .* (x - alpha_param).^2 + 1) + ...
        (x >= gamma_param & x < beta_param) .* C .* (x - beta_param).^2;
    
    
        %dongfanghong = [...
            %mid(5), 1;...
            %high(1), 1.5; mid(7), 0.5; high(2), 0.5; high(1), 0.5; mid(5), 0.5; mid(3), 0.5;...
            %mid(6), 1.5; mid(6), 0.5; mid(4), 1; pause(0), 1];

end
