import { Layout } from "antd";
import React from "react";
import Ingredients from "./Ingredients";
import Header from "./Header";

const { Content, Footer } = Layout;

export default () => (
  <Layout className="layout">
    <Header />
    <Content style={{ padding: "0 50px" }}>
      <div className="site-layout-content" style={{ margin: "100px auto" }}>
        <h1>Ingredients</h1>
        <Ingredients />
      </div>
    </Content>
    <Footer style={{ textAlign: "center" }}>Footer</Footer>
  </Layout>
);