function I = circle_scatter_image(loc, circ_diam, ax_lim)

    % Returns an image of filled circles of diameter circ_diam at the
    % locations specific by loc.

    % Known limitation: cannot generate images with resolutions exceeding
    % screen size due to limitation of getframe command
    
    % DWD 17-1031

    IM_map = zeros(640);
    
    fig = 10;
    figure(fig)
    clf
    hold on
    plot(loc(:,2),loc(:,1),'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',circ_diam)
    axis(ax_lim)
    
    set(gca,'visible', 'off');
    set(gcf,'color','white')
    set(gca,'Units','Pixels')
    set(gcf,'Units','Pixels')
    
    rect = [50 50 size(IM_map)];
    
    set(gcf,'Position',[rect(1:2) rect(3:4)*1.1])
    set(gca,'Position',rect)
    
    f = getframe(gcf,rect);
    close(fig)
    I = 255-(f.cdata);

end