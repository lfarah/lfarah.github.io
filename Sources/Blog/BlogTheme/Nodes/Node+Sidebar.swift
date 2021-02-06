//
//  Node+Sidebar.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Plot

extension Node where Context == HTML.BodyContext {
    static func sidebar(for site: Blog) -> Node {
        return .div(
            .class("sidebar pure-u-1 pure-u-md-1-4"),
            .div(
                .class("header"),
                .grid(
                    .div(
                        .class("pure-u-md-1-1 pure-u-1-4"),
                        .class("author__avatar"),
                        .img(
                            .src("https://avatars.githubusercontent.com/u/6511079?s=460&u=8c7104e93f8f45b1a397fb7f781dbe41ae6c82c5&v=4")
                        )
                    ),
                    .div(
                        .class("pure-u-md-1-1 pure-u-3-4"),
                        .h1(
                            .class("brand-title"),
                            .text(site.name)
                        ),
                        .h3(
                            .class("brand-tagline"),
                            .text(site.description)
                        )
                    )
                ),
                .grid(
                    .forEach(site.socialMediaLinks, { link in
                        .div(
                            .class("pure-u-md-1-1"),
                            .a(
                                .href(link.url),
                                .icon(link.icon),
                                .a(
                                    .class("social-media"),
                                    .href(link.url),
                                    .text(link.title)
                                )
                            )
                        )
                    })
                )
            )
        )
    }
}
