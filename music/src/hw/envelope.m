function [y, beta_param] = envelope(x)
    alpha_param = 0.075;
    gamma_param = 0.75;
    beta_param = 1.1;
    delta_param = 1 + (gamma_param-alpha_param)./(alpha_param-beta_param);
    A = -1./(alpha_param.^2);
    B = (delta_param-1)./(gamma_param-alpha_param).^2;
    C = (gamma_param-alpha_param)./(gamma_param-beta_param) .* B;
    
    y = ...
        (x >= 0 & x < alpha_param) .* (A .* (x-alpha_param).^2 + 1) + ...
        (x >= alpha_param & x < gamma_param) .* (B .* (x - alpha_param).^2 + 1) + ...
        (x >= gamma_param & x < beta_param) .* C .* (x - beta_param).^2;
end

